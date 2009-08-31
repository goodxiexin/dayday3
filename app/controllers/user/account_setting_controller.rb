class User::AccountSettingController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :owner_required

  def show
    @user = resource_owner
    render :action => 'reset_password'
  end

end
