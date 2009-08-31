class User::PasswordController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :owner_required 

  def edit
    @user = resource_owner
  end

  def update
    @user = resource_owner
    @old_password = params[:old_password]
    @new_password = params[:new_password]
    @confirmation = params[:confirmation]
    # check old password
    if User.authenticate(@user.email, @old_password) 
      if @new_password != @confirmation
        flash.now[:error] = "two passwords are not consistent"
        render :action => 'edit'
      else
        if session[:validation_text] != params[:validation_text]
          flash.now[:error] = "validation code error"
          render :action => 'edit' 
        else
          @user.password = @new_password
          if @user.save
            flash.now[:notice] = 'succeeded'
            render :action => 'edit'
          else
            flash.now[:error] = 'an error occurred, try it later'
            render :action => 'edit'
          end 
        end
      end
    else
      flash.now[:error] = "Old password is incorrect"
      render :action => 'edit' 
    end
  end

end
