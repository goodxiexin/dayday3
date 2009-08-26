class User::VideosController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :owner_required, :only => [:new, :create, :edit, :update, :confirm_destroy, :destroy]

  before_filter :record_visiting

  def index
    @user = resource_owner
    if relationship == 'owner'
      videos = @user.videos
    elsif relationship == 'friend'
      videos = @user.videos.find_friend_viewable(:all)
    else
      videos = @user.videos.find_public_viewable(:all)
    end
    @videos = videos.paginate :page => params[:page], :per_page => 10    
  end

  def new
    @user = resource_owner
    @video = Video.new
    @games = Game.all
  end

  def create
    @user = resource_owner
    Video.transaction do
      @video = Video.new(params[:video])
      @video.user = @user
      @video.link = Video.generate_link(@video.url)
      @video.save
      params[:tagged_users].each do |user_id|
        @video.tags.create(:user_id => @user.id, :tagged_user_id => user_id)
      end unless params[:tagged_users].blank?
    end
    render :update do |page|
      page.redirect_to user_videos_url(@user)#:action => 'index', :user_id => @user
    end
  rescue Video::VideoURLNotValid
    @games = Game.all
    flash[:error] = "only tudou and youku are supported"
    render :action => 'new'
  rescue
    @games = Game.all
    flash.now[:error] = "There was an error creating this video"
    render :action => 'new'
  end

  def show
    @user = resource_owner
    @video = @user.videos.find(params[:id])
    if @video.privilege == 'friends' and relationship != 'friend' and relationship != 'owner'
      flash[:error] = "This video is only viewable for friends"
      redirect_to new_user_friend_url(current_user, :friend_id => @user.id) 
    end
    if @video.privilege == 'myself' and relationship != 'owner'
      render :text => 'you are not allowed to view this video'
    end 
  rescue ActiveRecord::RecordNotFound
    render :text => 'video not found'
  end

  def edit
    @user = resource_owner
    @video = @user.videos.find(params[:id])
    @games = Game.all
  rescue ActiveRecord::RecordNotFound
    render :text => 'video not found'
  end

  def update
    @user = resource_owner
    @video = @user.videos.find(params[:id])
    Video.transaction do
      @video.update_attributes(params[:video])
      params[:tagged_users].each do |user_id|
        @video.tags.create(:user_id => @user.id, :tagged_user_id => user_id)
      end unless params[:tagged_users].blank?
    end
    render :update do |page|
      page.redirect_to user_videos_url(@user)
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'video not found'
  rescue
    @games = Game.all
    flash.now[:error] = 'There was a problem updating this blog'
    render :action => 'edit'
  end

  def confirm_destroy
    @user = resource_owner
    @video = Video.find(params[:id])
    render :action => 'confirm_destroy', :layout => false 
  rescue ActiveRecord::RecordNotFound
    render :text => 'video not found'
  end

  def destroy
    @user = resource_owner
    @video = @user.videos.find(params[:id])
    if session[:validation_text] == params[:validation_text]
      @video.destroy
      render :update do |page|
        page.redirect_to user_videos_url(@user)
      end
    else
      render :update do |page|
        page << "$('error').innerHTML = 'incorrect validation code'"
      end
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'video not found'
  end

  def new_tag
    vtags = []
    params[:tagged_users].each do |tagged_user_id|
      vtags << Vtag.new(:tagged_user_id => tagged_user_id)
    end
    render :partial => "user/vtags/vtag", :collection => vtags
  end

  def auto_complete_for_video_tags
    @user = current_user
    @friends = @user.friends.find_all {|f| f.login.include?(params[:video][:tags]) }
    render :partial => 'user/blogs/friends', :collection => @friends 
  end

end
