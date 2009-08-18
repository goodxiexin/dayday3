class UserVideosController < ApplicationController

  layout 'user'

  before_filter :login_required

  def index
    @user = User.find(params[:user_id])
    @videos = @user.videos.paginate :page => params[:page], :per_page => 10, :order => 'updated_at DESC'    
  end

  def new
    @user = User.find(params[:user_id])
    @video = Video.new
    @games = Game.all
  end

  def create
    @user = User.find(params[:user_id])
    Video.transaction do
      @video = Video.new(params[:video])
      @video.user = @user
      @video.link = Video.generate_link(@video.url)
      @video.save
      params[:tagged_users].each do |user_id|
        @blog.tags.create(:user_id => @user.id, :tagged_user_id => user_id)
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
    @user = User.find(params[:user_id])
    @video = Video.find(params[:id])   
  end

  def edit
    @user = User.find(params[:user_id])
    @video = Video.find(params[:id])
    @games = Game.all
  end

  def update
    @user = User.find(params[:user_id])
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
  rescue
    @games = Game.all
    flash.now[:error] = 'There was a problem updating this blog'
    render :action => 'edit'
  end

  def confirm_destroy
    @user = User.find(params[:user_id])
    @video = Video.find(params[:id])
    render :action => 'confirm_destroy', :layout => false 
  end

  def destroy
    @user = User.find(params[:user_id])
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
  end

  def new_tag
    vtags = []
    params[:tagged_users].each do |tagged_user_id|
      vtags << Vtag.new(:tagged_user_id => tagged_user_id)
    end
    render :partial => "vtag", :collection => vtags
  end

  def auto_complete_for_video_tags
    @user = current_user
    @friends = @user.friends.find_all {|f| f.login.include?(params[:video][:tags]) }
    render :partial => 'user_blogs/friends' 
  end

end
