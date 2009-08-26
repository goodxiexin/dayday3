class User::CommentNotificationsController < ApplicationController

  layout 'user'

  before_filter :owner_required

  def index
    @user = resource_owner
    notifications = []
    notifications.concat @user.scomment_notifications
    notifications.concat @user.vcomment_notifications
    notifications.concat @user.bcomment_notifications
    notifications.concat @user.pcomment_notifications
    notifications.sort! { |x,y| y.created_at <=> x.created_at }
    @notifications = notifications.paginate :page => params[:page], :per_page => 20
  end

end
