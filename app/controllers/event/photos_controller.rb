class Event::PhotosController < ApplicationController

  layout 'user'

  def show
    @event = Event.find(params[:event_id])
    @album = @event.album
    @user = @event.poster
    if @album.privilege == 'friends' and relationship != 'owner' and relationsihp != 'friend'
      flash[:error] = "This photo is only viewable for friends"
      redirect_to new_user_friend_url(current_user, :friend_id => @user.id)
    end
    if @album.privilege == 'myself' and relationship != 'owner'
      render :text => 'only owner is allowed to view this album'
    end
    @photo = @album.photos.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :text => 'photo not found'
  end

  def new
    @event = Event.find(params[:event_id])
    @album = @event.album
    @user = @event.poster
  end

  def create_multiple
    @event = Event.find(params[:event_id])
    @album = @event.album
    @user = @event.poster
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
    @event = Event.find(params[:event_id])
    @album = @event.album
    @user = @event.poster
    @photo = @album.photos.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :text => 'photo not found'
  end

  def edit_multiple
  end

  def update
    @event = Event.find(params[:event_id])
    @album = @event.album
    @user = @event.poster
    @photo = @album.photos.find(params[:id])
    Photo.transaction do
      unless params[:photo][:cover].blank?
        @album.reset_cover(@photo.id)
      end
      @photo.update_attributes(params[:photo])
    end
    redirect_to event_album_url(@event)
  rescue ActiveRecord::RecordNotFound
    render :text => 'photo not found'
  rescue
    flash.now[:error] = "There was an error updating this photo"
    render :action => 'edit'
  end

  def update_multiple
    @event = Event.find(params[:event_id])
    @album = @event.album
    @user = @event.poster
    Photo.transaction do
      params[:photos].each do |photo_id, photo_params|
        photo = Photo.find(photo_id)
        unless photo_params[:cover].blank?
          @album.reset_cover(photo_id)
        end
        photo.update_attributes(photo_params)
      end
    end
    redirect_to event_album_url(@event)
  rescue ActiveRecord::RecordNotFound
    render :text => 'photo not found'
  rescue
    flash.now[:error] = "There was an error updating these photos"
    render :action => 'edit_multiple'
  end

  def confirm_destroy
    @event = Event.find(params[:event_id])
    @album = @event.album
    @photo = @album.photos.find(params[:id])
    render :action => 'confirm_destroy', :layout => false
  rescue ActiveRecord::RecordNotFound
    render :text => 'photo not found'
  end

  def cover
    @event = Event.find(params[:event_id])
    @album = @event.album
    @photo = @album.photos.find(params[:id])
    @album.reset_cover(@photo.id)
    render :update do |page|
      page << "alert('succeeded')"
    end 
  rescue ActiveRecord::RecordNotFound
    render :text => 'photo not found'
  end

  def destroy
    @event = Event.find(params[:event_id])
    @album = @event.album
    @user = @event.poster
    @photo = @album.photos.find(params[:id])
    if session[:validation_text] == params[:validation_text]
      @photo.destroy
      render :update do |page|
        page.redirect_to event_album_url(@event)
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
