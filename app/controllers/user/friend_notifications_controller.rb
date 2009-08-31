class User::FriendNotificationsController < ApplicationController

  layout 'user'
  
  before_filter :login_required

  before_filter :owner_required

  def index
    @user = resource_owner
    @notifications = @user.friend_notifications
  end

end
