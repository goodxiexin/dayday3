class User::AlbumsController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :owner_required, :only => [:new, :create, :edit, :create, :confirm_destroy, :destroy]

  before_filter :permission_required, :only => [:index, :show]

  before_filter :record_visiting

  def index
    @user = resource_owner
    if relationship == 'owner'
      albums = @user.albums
    elsif relationship == 'friend'
      albums = @user.albums.find_friend_viewable(:all)
    else
      albums = @user.albums.find_public_viewable(:all)
    end
    @albums = @user.albums.paginate :page => params[:page], :per_page => 10
  end

  def show
    @user = resource_owner
    @album = @user.albums.find(params[:id])
    if @album.privilege == 'friends' and relationship != 'owner' and relationship != 'friend'
      flash[:error] = "This album is only viewable for friends"
      redirect_to new_user_friend_url(current_user, :friend_id => @user.id)
    end
    if @album.privilege == 'owner' and relationship != 'owner'
      render :text => 'you dont have permission to view this album'
    end
    @photos = @album.photos.paginate :page => params[:page], :per_page => 12, :order => 'position DESC'   
  rescue ActiveRecord::RecordNotFound
    render :text => 'album not found'
  end

  def new
    @user = resource_owner
    @album = Album.new
  end

  def edit
    @user = resource_owner
    @album = @user.albums.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :text => 'album not found'
  end

  def create
    @user = resource_owner
    @album = Album.new(params[:album])
    if @user.albums << @album
      redirect_to new_album_photo_url(@album)
    else
      flash.now[:error] = "There was an error while creating this album"
      render :action => 'new'
    end
  end

  def update
    @user = resource_owner
    @album = Album.find(params[:id])
    respond_to do |format|
      if @album.update_attributes(params[:album])
        format.html { redirect_to user_album_url(@user, @album) }
        format.xml { head :ok }
      else
	flash.now[:error] = "There was an error updating this album"
        format.html { render :action => 'edit' }
        format.xml { render :xml => @album.errors, :status => :unprocessable_entity }
      end
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'album not found'
  end

  def confirm_destroy
    @user = resource_owner
    @album = @user.albums.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :text => 'album not found'
  end

  def destroy
    @user = resource_owner
    @album = @user.albums.find(params[:id])
    if session[:validation_text] == params[:validation_text] 
      @album.destroy
      respond_to do |format|
        format.html { redirect_to user_albums_url(:user_id => @user) }
        format.xml  { head :ok }
      end
    else
      flash.now[:error] = "validation code error"
      render :action => 'confirm_destroy'
    end
  rescue ActiverRecord::RecordNotFound
    render :text => 'album not found'
  end 

end
