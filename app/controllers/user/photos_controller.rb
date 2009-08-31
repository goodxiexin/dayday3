class User::PhotosController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :owner_required, :only => [:new, :edit, :edit_multiple, :create_multiple, :update, :update_multiple, :confirm_destroy, :destroy,:cover]

  before_filter :permission_required, :only => [:index, :show]

  before_filter :record_visiting, :except => [:friends]

  def show
    @album = Album.find(params[:album_id])
    @user = resource_owner#@album.user
    if @album.privilege == 'friends' and relationship != 'owner' and relationship != 'friend'
      flash[:error] = "This photo is only viewable for friends"
      redirect_to new_user_friend_url(current_user, :friend_id => @user.id)
    end
    if @album.privilege == 'myself' and relationship != 'owner'
      render :text => 'only owner is allowed to view this album'
    end
    @photo = @album.photos.find(params[:id])
    @comments = @photo.comments.find_user_viewable(current_user.id, :all)
  rescue ActiveRecord::RecordNotFound
    render :text => 'photo not found'
  end

  def new
    @album = Album.find(params[:album_id])
    @user = resource_owner#@album.user
  end

  def create_multiple
    @album = Album.find(params[:album_id])
    @user = resource_owner #@album.user
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
    @user = resource_owner #@album.user
    @photo = @album.photos.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :text => 'photo not found'
  end

  def edit_multiple
  end

  def update
    @album = Album.find(params[:album_id])
    @user = resource_owner #@album.user
    @photo = @album.photos.find(params[:id])
    Photo.transaction do
      unless params[:photo][:cover].blank?
        album = @user.albums.find(params[:photo][:album_id])
        album.reset_cover(@photo.id)
      end
      @photo.update_attributes(params[:photo])
    end
    redirect_to user_album_url(@user, @album)
  rescue ActiveRecord::RecordNotFound
    render :text => 'photo not found'
  rescue
    flash.now[:error] = "There was an error updating this photo"
    render :action => 'edit'
  end

  def update_multiple
    @album = Album.find(params[:album_id])
    @user = resource_owner #@album.user
    Photo.transaction do
      params[:photos].each do |photo_id, photo_params|
        photo = Photo.find(photo_id)
        unless photo_params[:cover].blank?
          album = @user.albums.find(photo_params[:album_id])
          album.reset_cover(photo_id)
        end
        photo.update_attributes(photo_params)
      end
    end
    redirect_to user_album_url(@user, @album)
  rescue ActiveRecord::RecordNotFound
    render :text => 'photo not found'
  rescue
    flash.now[:error] = "There was an error updating these photos"
    render :action => 'edit_multiple'
  end

  def confirm_destroy
    @album = Album.find(params[:album_id])
    @photo = @album.photos.find(params[:id])
    render :action => 'confirm_destroy', :layout => false
  rescue ActiveRecord::RecordNotFound
    render :text => 'photo not found'
  end

  def cover
    @album = Album.find(params[:album_id])
    @photo = @album.photos.find(params[:id])
    @album.reset_cover(@photo.id)
    render :update do |page|
      page << "alert('succeeded')"
    end 
  rescue ActiveRecord::RecordNotFound
    render :text => 'photo not found'
  end

  def destroy
    @album = Album.find(params[:album_id])
    @user = resource_owner #@album.user
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
  rescue ActiveRecord::RecordNotFound
    render :text => 'photo not found'
  end

  def friends
    @friends = current_user.friends
    render :partial => 'friends', :object => @friends  
  end
  
end
