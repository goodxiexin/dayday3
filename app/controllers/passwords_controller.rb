class PasswordsController < ApplicationController

  layout 'root'

  before_filter :login_prohibited

  def new
  end

  def create
    if @user = User.find_by_email(params[:email])
      @user.forgot_password
      @user.save
      flash[:notice] = "A password reset link has been sent to your email address"
      redirect_to login_path
    else
      flash.now[:notice] = "could not find a user with that email address"
      render :action => 'new'
    end 
  end

  def edit
    if params[:password_reset_code].blank?
      flash.now[:error] = "invalid password reset code"
      render :action => 'new'
      return
    end
    @user = User.find_by_password_reset_code(params[:password_reset_code]) if params[:password_reset_code]
    if @user.blank?
      flash.now[:error] = "Sorry - That is an invalid password reset code. Please check your code and try again"
      render login_path
    end   
  end

  def update
    if params[:password_reset_code].blank?
      render :action => 'new'
      return
    end
    if params[:password].blank?
      flash[:notice] = "Password field cannot be blank"
      render :action => 'edit', :password_reset_code => params[:password_reset_code]
      return
    end
    @user = User.find_by_password_reset_code(params[:password_reset_code])
    return if @user.blank?
    if params[:password] == params[:password_confirmation]
      @user.password_confirmation = params[:password_confirmation]
      @user.password = params[:password]
      @user.reset_password
      flash[:notice] = @user.save ? "password reset" : "password not reset, do it again"
    else
      flash.now[:notice] = "Password mismatch"
      render :action => 'edit', :password_reset_code => params[:password_reset_code]
      return
    end
    redirect_to login_path
  end

end
