class MailboxesController < ApplicationController

  layout 'user'

  before_filter :login_required

  def index
    @user = current_user
    if params[:type] == 'recv'
      @mails = Mail.paginate :page => params[:page], :per_page => 10, :conditions => {:receiver_id => @user.id, :delete_by_receiver => false}, :order => 'created_at DESC'

      respond_to do |format|
        format.html { render :action => 'recv_index' }
        format.xml { render :xml => @mails }
      end
    elsif params[:type] == 'sent'
      @mails = Mail.paginate :page => params[:page], :per_page => 10, :conditions => {:sender_id => @user.id, :delete_by_sender => false}, :order => 'created_at DESC'

      respond_to do |format|
        format.html { render :action => 'sent_index' }
        format.xml { render :xml => @mails }
      end
    end
  end

  def show
    @user = current_user
    @mail = Mail.find(params[:id])
    @root_mail = @mail.parent
    @root_mail.children.each { |m| m.mark_as_read(@user.id) }
  end

  def new
    @user = current_user
  end

  def create
    @user = current_user
    Mail.transaction do
      params[:mail][:recipients].split(%r{,\s*}).each do |recipient_name|
        recipient = @user.friends.find_by_login(recipient_name)
        if recipient  # transaction????
          mail = Mail.new(params[:mail])
          mail.receiver = recipient
          mail.sender = @user
          mail.save
          mail.parent = mail
          mail.save
        end
      end
    end
    redirect_to :action => 'index', :type => 'sent'
  end

  def reply
    @root_mail = Mail.find(params[:id]).parent
    @mail = Mail.new(params[:mail])
    @mail.title = "reply to: #{@root_mail.title}"
    @mail.sender_id = current_user.id
    @mail.receiver_id = (@root_mail.sender == current_user)? @root_mail.receiver.id : @root_mail.sender.id
    @mail.parent_id = @root_mail.id

    respond_to do |format|
      if @mail.save
        format.html { render :partial => 'mail', :object => @mail }
        format.xml  { render :xml => @mail }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @mail.errors, :status => :unprocessable_entity }
      end
    end 
  end

  def destroy
    @user = current_user
    if params[:type] == 'recv'
      @mail = @user.recv_mails.find(params[:id])
      @mail.mark_delete(@user.id)
 
      respond_to do |format|
        format.html { redirect_to :action => 'index', :type => 'recv' }
        format.xml { header :ok }
      end     
    elsif params[:type] == 'sent'
      @mail = @user.sent_mails.find(params[:id])
      @mail.mark_delete(@user.id)

      respond_to do |format|
        format.html { redirect_to :action => 'index', :type => 'sent' }  
        format.xml  { header :ok }
      end
    end
  end

  def read_multiple
    @user = current_user
    params[:mail_ids].each do |mail_id|
      mail = Mail.find(mail_id)
      mail.mark_as_read(@user.id)
    end
  
    respond_to do |format| 
      format.html { render :text => "totally #{@user.recv_mails.count} mails | #{@user.unread_recv_mails_count} unread"}
      format.xml  { header :ok}
    end
  end

  def unread_multiple
    @user = current_user
    params[:mail_ids].each do |mail_id|
      mail = Mail.find(mail_id)
      mail.mark_as_unread(@user.id)
    end 

    respond_to do |format|
      format.html { render :text => "totally #{@user.recv_mails.count} mails | #{@user.unread_recv_mails_count} unread" }
      format.xml  { header :ok } 
    end 
  end

  def destroy_multiple
    @user = current_user
    params[:mail_ids].each do |mail_id|
      mail = Mail.find(mail_id)
      mail.mark_delete(@user.id)
    end

    respond_to do |format|
      format.html { render :text => url_for(:action => 'index', :type => params[:type]) }
      format.xml  { header :ok }
    end
  end

  def auto_complete_for_mail_recipients
    @user = current_user
    @friends = @user.friends.find_all {|f| f.login.include?(params[:mail][:recipients]) }
    render :partial => 'friend', :collection => @friends
  end

end
