class UserWallMessagesController < ApplicationController

  layout 'user'

  before_filter :login_required

  def index
    @user = User.find(params[:user_id])
    @wall_messages = WallMessage.paginate :page => params[:page], :per_page => 20, :conditions => "user_id = #{@user.id} OR receiver_id = #{@user.id}", :order => 'created_at DESC' 
    @wall_message = WallMessage.new
    @wall_message.receiver_id = params[:user_id]
  end

  def new
    @user = User.find(params[:user_id])
    @wall_messages = @user.wall_messages[0, 10] # get most recent 10 wall messages
    @wall_message = WallMessage.new
    @wall_message.receiver_id = params[:user_id]
  end

  def create
    @user = User.find(params[:user_id])
    @wall_message = WallMessage.new(params[:wall_message])
    @wall_message.poster_id = current_user.id
    @wall_message.user_id = params[:user_id]
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
  end

end
