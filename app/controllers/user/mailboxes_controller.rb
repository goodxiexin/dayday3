class User::MailboxesController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :owner_required, :except => [:auto_complete_for_mail_recipients]

  def index
    @user = resource_owner
    if params[:type] == 'recv'
      @mails = Mail.paginate :page => params[:page], :per_page => 10, :conditions => {:receiver_id => @user.id, :delete_by_receiver => false}, :order => 'created_at DESC'
      render :action => 'recv_index'
    elsif params[:type] == 'sent'
      @mails = Mail.paginate :page => params[:page], :per_page => 10, :conditions => {:sender_id => @user.id, :delete_by_sender => false}, :order => 'created_at DESC'
      render :action => 'sent_index'
    end
  end

  def show
    @user = resource_owner
    @mail = Mail.find(params[:id])
    @root_mail = @mail.parent
    Mail.transaction do
      @root_mail.children.each { |m| m.mark_as_read(@user.id) }
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'mail not found'
  rescue 
    flash[:error] = "There was an error"
    redirect_to user_mails_url(@user, :type => 'recv')
  end

  def new
    @user = resource_owner
    unless params[:receiver_id].blank?
      @receiver = User.find(params[:receiver_id])
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'recipient not found'
  end

  def create
    @user = resource_owner
    Mail.transaction do
      params[:mail][:recipients].split(%r{,\s*}).each do |recipient_name|
        recipient = @user.friends.find_by_login(recipient_name)
        if recipient
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
    @user = resource_owner
    @root_mail = Mail.find(params[:id]).parent
    @mail = Mail.new(params[:mail])
    @mail.title = "reply to: #{@root_mail.title}"
    @mail.sender_id = @user.id
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
  rescue ActiveRecord::RecordNotFound
    render :text => 'mail not found' 
  end

  def destroy
    @user = resource_owner
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
  rescue ActiveRecord::RecordNotFound
    render :text => 'mail not found'
  end

  def read_multiple
    @user = resource_owner
    Mail.transaction do
      params[:mail_ids].each do |mail_id|
        mail = Mail.find(mail_id)
        mail.mark_as_read(@user.id)
      end
    end
    respond_to do |format| 
      format.html { render :text => "totally #{@user.recv_mails.count} mails | #{@user.unread_recv_mails_count} unread"}
      format.xml  { header :ok}
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'mail not found'
  rescue
    flash[:error] = "There was an error marking read"
    redirect_to user_mails_url(@user, :type => 'recv')
  end

  def unread_multiple
    @user = resource_owner
    Mail.transaction do
      params[:mail_ids].each do |mail_id|
        mail = Mail.find(mail_id)
        mail.mark_as_unread(@user.id)
      end
    end 
    respond_to do |format|
      format.html { render :text => "totally #{@user.recv_mails.count} mails | #{@user.unread_recv_mails_count} unread" }
      format.xml  { header :ok } 
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'mail not found'
  rescue
    flash[:error] = "There was an error marking unread"
    redirect_to user_mails_url(@user, :type => 'recv') 
  end

  def destroy_multiple
    @user = resource_owner
    Mail.transaction do
      params[:mail_ids].each do |mail_id|
        mail = Mail.find(mail_id)
        mail.mark_delete(@user.id)
      end
    end
    respond_to do |format|
      format.html { render :text => url_for(:action => 'index', :type => params[:type]) }
      format.xml  { header :ok }
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'mail not found'
  rescue
    flash[:error] = "There was an error deleting"
    redirect_to user_mails_url(@user, :type => 'recv')
  end

  def auto_complete_for_mail_recipients
    @user = current_user
    @friends = @user.friends.find_all {|f| f.login.include?(params[:mail][:recipients]) }
    render :inline => "<%= auto_complete_result @friends, 'login' %>"
  end

end
