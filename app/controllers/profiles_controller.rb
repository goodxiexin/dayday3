class ProfilesController < ApplicationController

  layout 'user'

  before_filter :login_required

  def show
    @user = User.find(params[:user_id])
  end

end
