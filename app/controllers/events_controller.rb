class EventsController < ApplicationController
  layout 'event'

  def index
  end

  def new
    @event = Event.new
    @games = Game.all
  end

  def show
    @event = Event.find_by_id(params[:id])   
  end

  def create
    @event = Event.new(params[:event])
    event_album = Album.new
    @event.album_id = event_album.id
    @event.poster_id = current_user.id
    @event.save
    flash[:notice] = "Event is successfully created"
    redirect_to "/participations/new?event_id="+String(@event.id)
  end

  def update
  end

  def edit
  end

  def destroy
  end
end
