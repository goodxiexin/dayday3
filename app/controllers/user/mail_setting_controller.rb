class User::MailSettingController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :owner_required

  def edit
    @user = resource_owner
    @setting = @user.mail_setting
  end

  def update
    @user = resource_owner
    @setting = @user.mail_setting
    if @setting.update_attributes(params[:setting])
      flash.now[:notice] = "succeeded"
      render :action => 'edit'
    end
  end

end
