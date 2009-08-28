class Event::AlbumController < ApplicationController

  layout 'user'

  def index
  end

  def show
    @event = Event.find(params[:event_id])
    @user = @event.poster
    @album = @event.album
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
  end

  def edit
    @event = Event.find(params[:event_id])
    @album = @event.album
    @user = @event.poster
  rescue ActiveRecord::RecordNotFound
    render :text => 'album not found'
  end

  def create
  end

  def update
    @event = Event.find(params[:event_id])
    @user = @event.poster
    @album = @event.album
    if @album.update_attributes(params[:album])
      flash[:notice] = "update successful"
      redirect_to event_album_url(@event)
    else
      flash.now[:error] = "There was an error updating this album"
      render :action => 'edit'
    end
  end

  def confirm_destroy
    @event = Event.find(params[:event_id])
    @user = @event.poster
    @album = @event.album
  rescue ActiveRecord::RecordNotFound
    render :text => 'album not found'
  end

  def destroy
    @event = Event.find(params[:event_id])
    @user = @event.poster
    @album = @event.album
    if session[:validation_text] == params[:validation_text] 
      @album.destroy
      respond_to do |format|
        format.html { redirect_to event_album_url(:event_id => @event) }
        format.xml  { head :ok }
      end
    else
      flash.now[:error] = "validation cod
e error"
      render :action => 'confirm_destroy'
    end
  rescue ActiverRecord::RecordNotFound
    render :text => 'album not found'
  end 

end
