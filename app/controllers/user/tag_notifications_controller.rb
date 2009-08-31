class User::TagNotificationsController < ApplicationController

  layout 'user'

  before_filter :owner_required

  def index
    @user = resource_owner
    @notifications = @user.tag_notifications.paginate :page => params[:page], :per_page => 20 
  end

  def read_multiple
    @user = resource_owner
    TagNotification.transaction do 
      params[:ids].each do |id|
        TagNotification.find(id).update_attribute('read', true)
      end
    end
    render :nothing => true
  rescue
    flash[:error] = "There was an error"
    redirert_to user_tag_notifications_url(@user)
  end

end
