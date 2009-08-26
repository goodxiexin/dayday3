class User::IconsController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :owner_required, :only => [:new, :edit, :set, :create, :update, :confirm_destroy, :destroy]

  def index
    @user = resource_owner
    @icons = @user.icons.paginate :page => params[:page], :per_page => 12 
  end

  def show
    @user = resource_owner
    @icon = @user.icons.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :text => 'icon not found'
  end

  def new
    @user = resource_owner
    render :action => 'new', :layout => false
  end

  def edit
    @user = resource_owner
    @icon = @user.icons.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :text => 'icon not found'
  end

  def create
    @user = resource_owner
    @icon = Photo.new(params[:icon])
    @old_icon = @user.current_icon
    @old_icon.update_attribute('current_icon', false) unless @old_icon.blank?
    @icon.user = @user
    @icon.current_icon = true
  
    if @icon.save
      @user.reload
      responds_to_parent do
        render :update do |page|
          page << "facebox.close()"
          if params[:album].to_i == 1
            page.redirect_to user_icons_url(@user)
          else
            page.replace_html 'user_icon', user_icon(@user, :medium)
          end
        end
      end
    else
      responds_to_parent do
        render :update do |page|
          page << "$('error').innerHTML = 'There was an error uploading this icon"
        end
      end
    end
  end

  def set
    @user = resource_owner
    @icon = @user.icons.find(params[:id])
    @old_icon = @user.current_icon
    @old_icon.update_attribute('current_icon', false) unless @old_icon.blank?
    @icon.user = @user
    @icon.current_icon = true
    if @icon.save
      render :update do |page|
        page << "alert('success');"
      end
    else
      render :update do |page|
        page << " alert('an error occurred, try it later');"
      end
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'icon not found'
  end

  def update
    @user = resource_owner
    @icon = @user.icons.find(params[:id])
    if @icon.update_attributes(params[:icon])
      redirect_to user_icons_url(@user)
    else
      flash.now[:error] = "There was an error updating this icon"
      render :action => 'edit'
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'icon not found'
  end

  def confirm_destroy
    @user = resource_owner
    @icon = @user.icons.find(params[:id])
    render :action => 'confirm_destroy', :layout => false
  rescue ActiveRecord::RecordNotFound
    render :text => 'icon not found'
  end

  def destroy
    @user = resource_owner
    @icon = @user.icons.find(params[:id])

    if session[:validation_text] == params[:validation_text]
      @icon.destroy
      render :update do |page|
        page.redirect_to user_icons_url(@user)
      end
    else
      render :update do |page|
        page << "$('error').innerHTML = 'incorrect validation code'"
      end
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'icon not found'
  end

end
