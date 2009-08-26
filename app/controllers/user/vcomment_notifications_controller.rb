class User::VcommentNotificationsController < ApplicationController

  before_filter :owner_required

  def read_multiple
    @user = resource_owner
    VcommentNotification.transaction do 
      params[:ids].each do |id|
        @notification = VcommentNotification.find(id)
        @notification.update_attribute('read', true)
      end
    end
    render :nothing => true
  rescue
    flash[:error] = "There was an error"
    redirect_to user_comment_notifications_url(@user)
  end


end
