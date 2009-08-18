class UserBlogsController < ApplicationController

  layout 'user'

  before_filter :login_required, :except => [:index, :show]

  def index
    @user = User.find(params[:user_id])
    if params[:draft].to_i == 0
      @blogs = @user.blogs.paginate :page => params[:page], :per_page => 10, :order => 'updated_at DESC'
      render :action => 'blogs_index'
    elsif params[:draft].to_i == 1
      @blogs = @user.drafts.paginate :page => params[:page], :per_page => 10, :order => 'updated_at DESC'
      render :action => 'drafts_index'
    end
  end

  def show
    @user = User.find(params[:user_id])
    @blog = @user.blogs.find(params[:id])
  end

  def new
    @user = User.find(params[:user_id])
    @blog = Blog.new
  end

  def create
    @user = User.find(params[:user_id])
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
    @blog = Blog.find(params[:id])
    @user = User.find(params[:user_id])
  end

  def update
    @user = User.find(params[:user_id])
    @blog = @user.blogs.find(params[:id])
    Blog.transaction do
      @blog.update_attributes(params[:blog])
      params[:tagged_users].each do |user_id|
        @blog.tags.create(:user_id => @user.id, :tagged_user_id => user_id)
      end unless params[:tagged_users].blank?
    end
    render :update do |page|
      page.redirect_to user_blogs_url(:user_id => @user, :draft => params[:blog][:draft])
    end
  rescue
    falsh.now[:error] = 'There was a problem updating this blog'
    render :action => 'edit'
  end

  def confirm_destroy
    @user = User.find(params[:user_id])
    @blog = Blog.find(params[:id])
    render :action => 'confirm_destroy', :layout => false
  end 

  def destroy
    @user = current_user
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
  end

  def destroy_multiple
    @user = User.find(params[:user_id])
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
    render :partial => "btag", :collection => btags
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
    render :partial => 'popup_tag'
  end

  def auto_complete_for_blog_tags
    @user = current_user
    @friends = @user.friends.find_all {|f| f.login.include?(params[:blog][:tags]) }
    render :partial => 'friends' 
  end

end
