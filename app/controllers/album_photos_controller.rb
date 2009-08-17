class AlbumPhotosController < ApplicationController

  layout 'user'

  before_filter :login_required

  def show  
    @album = Album.find(params[:album_id])
    @user =  @album.user
    @photo = @album.photos.find(params[:id])
  end

  def new
    @album = Album.find(params[:album_id])
    @user = @album.user
  end

  def create_multiple
    @album = Album.find(params[:album_id])
    @user = @album.user
    @photos = []
    @migration = 0
    params[:photos].each do |photo_attributes|
      photo = Photo.new(photo_attributes)
      photo.album = @album
      if photo.save
        @photos << photo
      end
    end

    respond_to do |format|
      format.html { render :action => 'edit_multiple' }
      format.xml  { render :xml => @photos }
    end 
  end

  def edit
    @album = Album.find(params[:album_id])
    @user = @album.user
    @photo = @album.photos.find(params[:id])
  end

  def edit_multiple
    @album = Album.find(params[:album_id])
    @user = @album.user
    @photos = Photo.find(:all, :conditions => {:id => params[:id]})
  end

  def update
    @album = Album.find(params[:album_id])
    @user = @album.user
    @photo = @album.photos.find(params[:id])
    Photo.transaction do
      unless params[:photo][:cover].blank?
        album = Album.find(params[:photo][:album_id])
        album.reset_cover(@photo.id)
      end
      @photo.update_attributes(params[:photo])
    end
    redirect_to user_album_url(@user, @album)
  rescue
    flash.now[:error] = "There was an error updating this photo"
    render :action => 'edit'
  end

  def update_multiple
    @album = Album.find(params[:album_id])
    @user = @album.user
    Photo.transaction do
      params[:photos].each do |photo_id, photo_params|
        photo = Photo.find(photo_id)
        unless photo_params[:cover].blank?
          album = Album.find(photo_params[:album_id])
          album.reset_cover(photo_id)
        end
        photo.update_attributes(photo_params)
      end
    end
    redirect_to user_album_url(@user, @album)
  rescue
    flash.now[:error] = "There was an error updating these photos"
    render :action => 'edit_multiple'
  end

  def confirm_destroy
    @album = Album.find(params[:album_id])
    @photo = @album.photos.find(params[:id])
    render :action => 'confirm_destroy', :layout => false
  end

  def cover
    @album = Album.find(params[:album_id])
    @photo = @album.photos.find(params[:id])
    @album.reset_cover(@photo.id)
    render :update do |page|
      page << "alert('succeeded')"
    end 
  end

  def destroy
    @album = Album.find(params[:album_id])
    @user = @album.user
    @photo = @album.photos.find(params[:id])

    if session[:validation_text] == params[:validation_text]
      @photo.destroy
      render :update do |page|
        page.redirect_to user_album_url(@user, @album)
      end
    else
      render :update do |page|
        page << "$('error').innerHTML = 'incorrect validation code'"
      end
    end
  end

  def friends
    @friends = current_user.friends
    render :partial => 'friends', :object => @friends  
  end
  
end
