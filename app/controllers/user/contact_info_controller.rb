class User::ContactInfoController < ApplicationController

  before_filter :login_required

  before_filter :owner_required, :only => [:edit, :udpate]

  def edit
    @user = resource_owner
  end

  def update
    @user = resource_owner
    if @user.update_attributes(params[:user]) 
      render :update do |page|
        page.replace_html 'contact_info', :partial => 'show'
        page << "facebox.close();facebox.watchClickEvents()"
      end
    else
      render :update do |page|
        page << "$('error').innerHTML = 'There was an error updating your profile'"
      end
    end
  end

end
