class User::PrivacySettingController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :owner_required

  def show
    @user = resource_owner
    @setting = @user.privacy_setting 
  end

  def edit
    @user = resource_owner
    @setting = @user.privacy_setting
    case params[:type].to_i
    when 1
      render :partial => 'personal_page'
    when 2
      render :partial => 'friend_request'
    when 3
      render :partial => 'search'
    end
  end

  def update
    @user = resource_owner
    @setting = @user.privacy_setting
    if @setting.update_attributes(params[:setting])
      render :update do |page|
        case params[:type].to_i
        when 1
          page << "$('personal_show').innerHTML = '#{show_personal_setting @setting}';"
          page.visual_effect :highlight, 'personal_show', :duration => 1
        when 2
          page << "$('friend_show').innerHTML = '#{show_friend_setting @setting}';"
          page.visual_effect :highlight, 'friend_show', :duration => 1
        when 3
          @setting.update_attribute('search', false) if params[:setting].blank?
          page << "$('search_show').innerHTML = '#{show_search_setting @setting}';"
          page.visual_effect :highlight, 'search_show', :duration => 1
        end
        page << "facebox.close();"
      end
    else
      render :update do |page|
        page << "$('error').innerHTML = 'an error occurred, try it later';"
      end
    end
  end

end
