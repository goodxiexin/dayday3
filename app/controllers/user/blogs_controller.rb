class User::BlogsController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :owner_required, :only => [:new, :create, :edit, :update, :confirm_destroy, :destroy, :destroy_multiple]

  before_filter :record_visiting

  def index
    @user = resource_owner
    if params[:draft].to_i == 0
      if relationship == 'owner'
        blogs = @user.blogs
      elsif relationship == 'friend'
        blogs = @user.blogs.find_friend_viewable(:all)
      else
        blogs = @user.blogs.find_public_viewable(:all)
      end
      @blogs = blogs.paginate :page => params[:page], :per_page => 10
      render :action => 'blogs_index'
    elsif params[:draft].to_i == 1
      @blogs = @user.drafts.paginate :page => params[:page], :per_page => 10, :order => 'position DESC'
      render :action => 'drafts_index'
    end
  end

  def show
    @user = resource_owner
    @blog = @user.blogs.find(params[:id])
    logger.error @blog.privilege
    if @blog.privilege == 'friends' and relationship != 'friend' and relationship != 'owner'
      flash[:error] = "This blog is only viewable for friends"
      redirect_to new_user_friend_url(current_user, :friend_id => @user.id)
    end
    if @blog.privilege == 'myself' and relationship != 'owner'
      render :text => 'you dont have permission to view that blog'
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'blog not found'
  end

  def new
    @user = resource_owner
    @blog = Blog.new
  end

  def create
    @user = resource_owner
    Blog.transaction do
      @blog = Blog.new(params[:blog])
      @blog.user = @user
      @blog.save
      params[:tagged_users].each do |user_id|
        @blog.tags.create(:user_id => @user.id, :tagged_user_id => user_id)
      end unless params[:tagged_users].blank?
    end
    render :update do |page|
      page.redirect_to user_blogs_url(current_user, :draft => params[:blog][:draft])
    end
  rescue # transaction aborts
    flash.now[:error] = "There was an error while saving this blog"
    render :action => 'new'
  end

  def edit
    @user = resource_owner
    @blog = @user.blogs.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :text => 'blog not found'
  end

  def update
    @user = resource_owner
    @blog = @user.blogs.find(params[:id])
    Blog.transaction do
      if @blog.draft and params[:blog][:draft].to_i == 0
        @blog.update_attributes(params[:blog].merge({:created_at => Time.now.to_s(:db)}))
        @blog.add_to_list_bottom
      elsif !@blog.draft and params[:blog][:draft].to_i == 1
        @blog.update_attributes(params[:blog])
        @blog.remove_from_list
      end
      @blog.update_attributes(params[:blog])
      params[:tagged_users].each do |user_id|
        @blog.tags.create(:user_id => @user.id, :tagged_user_id => user_id)
      end unless params[:tagged_users].blank?
    end
    render :update do |page|
      page.redirect_to user_blogs_url(:user_id => @user, :draft => params[:blog][:draft])
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'blog not found'
  rescue
    @games = Game.all
    flash.now[:error] = 'There was a problem updating this blog'
    render :action => 'edit'
  end

  def confirm_destroy
    @user = resource_owner
    @blog = @user.blogs.find(params[:id])
    render :action => 'confirm_destroy', :layout => false
  rescue ActiveRecord::RecordNotFound
    render :text => 'blog not found' 
  end 

  def destroy
    @user = resource_owner
    @blog = @user.blogs.find(params[:id])
    if session[:validation_text] == params[:validation_text]
      @blog.destroy
      render :update do |page|
        page.redirect_to user_blogs_url(:user_id => @user, :draft => params[:draft])
      end
    else
      render :update do |page|
        page << "$('error').innerHTML = 'incorrect validation code'"
      end
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'blog not found'  
  end

  def destroy_multiple
    @user = resource_owner
    Blog.transaction do
      params[:blogs].each { |id| @user.drafts.find(id).destroy }
    end
    render :update do |page|
      page.redirect_to user_blogs_url(:user_id => @user, :draft => 1)
    end
  rescue
    flash.now[:error] = 'There was a problem deleting these drafts'
    render :action => 'index', :draft => 1
  end

  def new_tag
    btags = []
    params[:tagged_users].each do |tagged_user_id|
      btags << Btag.new(:tagged_user_id => tagged_user_id)
    end
    render :partial => "user/btags/btag", :collection => btags
  end

  def games_list
    @user = current_user
    render :partial => 'games_list', :object => @user.games
  end

  def friends_list
    @user  = current_user
    if params[:game_id] == 'all'
      @friends = @user.friends
    else
      game = Game.find(params[:game_id])
      @friends = @user.friends.find_all {|f| f.games.include?(game) }
    end
    render :partial => 'friends_list', :object => @friends
  end

  def show_popup_tag
    @user = User.find(params[:tagged_user_id])
    render :partial => 'user/personal/popup_tag'
  end

  def auto_complete_for_blog_tags
    @user = current_user
    @friends = @user.friends.find_all {|f| f.login.include?(params[:blog][:tags]) }
    render :partial => 'friends' 
  end

end
