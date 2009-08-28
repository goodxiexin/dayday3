class EventsController < ApplicationController
  layout 'event'

  def index
    @user = current_user
    case params[:term]
      when 'up_coming'
        games_id = []
        @user.games.each do |game|
          games_id << game.id
        end
        #could not find a way to combine IN games_id with time > Time.now!!!
        events = Event.find(:all,:conditions => {:game_id => games_id})
        @events = events.paginate :page => params[:page], :per_page => 10, :order => 'time ASC'
      when 'mine'
        @events = @user.events.paginate :page => params[:page], :per_page => 10, :order => 'time ASC'
      when 'game'
        events = Event.find(:all,:conditions => ["game_id = :game_id AND time > :time", {:game_id => params[:game_id], :time => Time.now }])          
        @events = events.paginate :page => params[:page], :per_page => 10, :order => 'time ASC'
    end
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
    event_album = Album.create(:game_id => @event.game_id, :title => @event.title+' event album', :user_id => current_user.id)
    @event.album_id = event_album.id
    @event.poster_id = current_user.id
    @event.save
    @event.participations.create(:inviter_id => current_user.id, :participant_id => current_user.id, :event_status => 4)
    flash[:notice] = "Event is successfully created"
    redirect_to "/participations/new?event_id="+String(@event.id)
  end

  def update
  end

  def edit
  end

  def confirm_destroy
    @event = Event.find(params[:id])
    render :action => 'confirm_destroy', :layout => false
  rescue ActiveRecord::RecordNotFound
    render :text => 'event not found'
  end

  def destroy
    @event = Event.find(params[:id])
    if session[:validation_text] == params[:validation_text]
      @event.destroy
      render :update do |page|
        page.redirect_to user_personal_url(current_user)
      end
    else
      render :update do |page|
        page << "$('error').innerHTML = 'incorrect validation code'"
      end
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'event not found'
  end

  def game_details
    @game = Game.find(params[:game_id])
    if @game.no_areas
      @servers = @game.servers
    else
      @areas = @game.areas
      @servers = []
    end
    render :partial => 'game_details' 
  end

  def area_details
    @game_area = GameArea.find(params[:area_id])
    @servers = @game_area.servers
    render :partial => 'server_select', :locals => {:servers => @servers, :server_id => nil}
  end

end
