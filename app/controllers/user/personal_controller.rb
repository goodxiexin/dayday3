class User::PersonalController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :permission_required
 
  before_filter :record_visiting

  def show
    @user = resource_owner
    @wall_messages = @user.wall_messages[0, 10] # get most recent 10 wall messages
    @wall_message = WallMessage.new
  end

end
