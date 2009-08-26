class User::PersonalController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :record_visiting

  def show
    @user = User.find(params[:user_id])
  end

end
