class User::WallMessagesController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :owner_required, :only => [:destroy]

  before_filter :record_visiting

  def index
    @user = resource_owner
    @wall_messages = WallMessage.paginate :page => params[:page], :per_page => 10, :order => 'created_at DESC', :conditions => {:user_id => @user.id, :receiver_id => @user.id} #@user.wall_messages.paginate :page => params[:page], :per_page => 10
    @wall_message = WallMessage.new
    @wall_message.receiver_id = @user.id
  end

  def new
    @user = resource_owner
    @wall_messages = @user.wall_messages[0, 10] # get most recent 10 wall messages
    @wall_message = WallMessage.new
    render :action => 'new', :layout => false
  end

  def create
    @user = resource_owner
    @wall_message = WallMessage.new(params[:wall_message])
    @wall_message.poster_id = current_user.id
    @wall_message.user_id = @user.id
    @wall_message.save
 
    respond_to do |format|
      format.html { render :partial => 'wall_message', :object => @wall_message }
      format.xml  { render :xml => @wall_message }
    end
  end

  def destroy
    @wall_message = WallMessage.find(params[:id])
    @wall_message.destroy 
    
    respond_to do |format|
      format.html { render :nothing => true }
      format.xml  { head :ok }
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'wall message not found' 
  end

end
