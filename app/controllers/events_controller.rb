class EventsController < ApplicationController
  layout 'event'

  def index
  end

  def new
    @event = Event.new
    @games = Game.all
  end

  def show
    @event = Event.find(params[:id])
    @user = User.find(@event.poster_id)
    @game = Game.find(@event.game_id)
    @game_server = GameServer.find(@event.game_server_id)
    @game_area = GameArea.find(@event.game_area_id) unless @event.game_area_id.nil? 

    @event_wall_messages = @event.event_wall_messages[0, 10] # get most recent 10 event wall messages
    @event_wall_message = EventWallMessage.new
    @event_wall_message.receiver_id = @user.id
    @event_wall_message.event_id = @event.id

    @album = @event.album
    @photos = @album.photos.paginate :page => params[:page], :per_page => 4, :order => 'updated_at DESC' # get most recent 5 photos
  end

  def create
    @event = Event.new(params[:event])
    event_album = Album.create(:game_id => @event.game_id, :title => @event.title+'\'s album', :user_id => current_user.id)
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
