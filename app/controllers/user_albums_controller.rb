class UserAlbumsController < ApplicationController

  layout 'user'

  before_filter :login_required

  def index
    @user = User.find(params[:user_id])
    @albums = @user.albums.paginate :page => params[:page], :per_page => 10, :order => 'updated_at DESC'
  end

  def show
    @user = User.find(params[:user_id])
    @album = @user.albums.find(params[:id])
    @photos = @album.photos.paginate :page => params[:page], :per_page => 12, :order => 'updated_at DESC'   
  end

  def new
    @user = User.find(params[:user_id])  
    @album = Album.new
  end

  def edit
    @user = User.find(params[:user_id])
    @album = Album.find(params[:id]) 
  end

  def create
    @user = User.find(params[:user_id])
    @album = Album.new(params[:album])
    if @user.albums << @album
      redirect_to :controller => 'album_photos', :action => 'new', :album_id => @album#new_album_photos_url(@album)
    else
      flash.now[:error] = "There was an error while creating this album"
      render :action => 'new'
    end
  end

  def update
    @user = User.find(params[:user_id])
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
  end

  def confirm_destroy
    @user = User.find(params[:user_id])
    @album = Album.find(params[:id])
  end

  def destroy
    @user = User.find(params[:user_id])
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
  end 

end
