# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  
  layout 'root'

  before_filter :login_required, :only => :destroy

  def new
  end

  def create
    self.current_user = User.authenticate(params[:email], params[:password])
    if current_user == nil
      flash.now[:error] = "your username or password is incorrect"
      render :action => 'new'
    elsif !current_user.active?
      flash.now[:error] = "your account is not active, please check your email for activation code."
      render :action => 'new'
    elsif current_user.enabled == false
      flash.now[:error] = "Your account has been disabled"
      render :action => 'new'
    else
      if params[:remember_me] == "1"
        current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      if current_user.has_role?('Administrator')
        redirect_back_or_default('/pages')
      else
        redirect_back_or_default(user_personal_url(current_user))
      end
      flash[:notice] = "Logged in successfully"
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to login_url
  end
end
