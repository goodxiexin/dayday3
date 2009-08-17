class BasicInfoController < ApplicationController

  before_filter :login_required

  def edit
    @user = User.find(params[:user_id])  
  end

  def update
    @user = User.find(params[:user_id])
    if @user.update_attributes(params[:user])
      @user.update_attribute('birthday', "#{params[:user][:birthday][:year]}-#{params[:user][:birthday][:month]}-#{params[:user][:birthday][:day]}")
      render :update do |page|
        page.replace_html 'basic_info', :partial => 'show'
        page << "facebox.close();facebox.watchClickEvents()"
      end
    else
      render :update do |page|
        page << "$('error').innerHTML = 'There was an error updating your profile'"
      end
    end
  end

end
