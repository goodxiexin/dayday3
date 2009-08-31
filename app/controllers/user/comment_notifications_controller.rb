class User::CommentNotificationsController < ApplicationController

  layout 'user'

  before_filter :owner_required

  def index
    @user = resource_owner
    @notifications = @user.comment_notifications.paginate :page => params[:page], :per_page => 20
  end

  def read_multiple
    @user = resource_owner
    CommentNotification.transaction do
      params[:ids].each do |id|
        CommentNotification.find(id).update_attribute('read', true)
      end
    end
    render :nothing => true
  rescue
    flash[:error] = "There was an error"
    redirect_to user_comment_notifications_url(@user)
  end

end
