class User::FriendRequestsController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :owner_required

  def index
    @user = resource_owner
    @requests = @user.friend_requests.paginate :page => params[:page], :per_page => 10
  end

  def new
    @sender = resource_owner
    @receiver = User.find(params[:receiver_id])
    if FriendRequest.find(:first, :conditions => {:sender_id => @sender.id, :receiver_id => @receiver.id})
      render :text => "<br/><h3>你已经加他为好友了，请耐心等待回复</h3><br/>"
    else
      render :action => 'new', :layout => false
    end 
  end

  def create
    @sender = resource_owner
    @friend_request = FriendRequest.new(params[:request])
    @friend_request.sender = @sender
    if @friend_request.save
      render :update do |page|
        page << "facebox.close()"
      end
    else
      render :update do |page|
        page << "$('error').innerHTML = 'some error occurred, try it later';"
      end
    end
  end

  def confirm_destroy
    @user = resource_owner
    @request = FriendRequest.find(params[:id])
    render :action => 'confirm_destroy', :layout => false
  rescue ActiveRecord::RecordNotFound
    render :text => 'request not found'
  end

  def destroy
    @request = FriendRequest.find(params[:id])
    (params[:accept].to_i == 1)? @request.accept : @request.decline
    FriendRequest.transaction do 
      Friendship.create(:user_id => @request.sender.id, :friend_id => @request.receiver.id)
      Friendship.create(:user_id => @request.receiver.id, :friend_id => @request.sender.id)
      @request.destroy
    end
    if params[:accept].to_i == 1
      render :action => 'accept', :layout => false
    else
      render :update do |page|
        page << "$('friend_request_#{@request.id}').remove();facebox.close();"
      end
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'request not found'
  rescue 
    render :text => 'some error occurred'
  end

end
