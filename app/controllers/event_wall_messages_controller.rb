class EventWallMessagesController < ApplicationController

  def index
  end

  def new
    @event = Event.find(params[:id])
    @event_wall_messages = @event.event_wall_messages[0, 10] # get most recent 10 wall messages
    @event_wall_message = EventWallMessage.new
    @event_wall_message.event_id = params[:id]
  end

  def create
    @event_wall_message = EventWallMessage.new(params[:event_wall_message])
    @event_wall_message.poster_id = current_user.id
    @event_wall_message.save

    respond_to do |format|
      format.html { render :partial => 'event_wall_message', :object => @event_wall_message }
      format.xml  { render :xml => @event_wall_message }
    end
  end

  def destroy
    @event_wall_message = EventWallMessage.find(params[:id])
    @event_wall_message.destroy

    respond_to do |format|
      format.html { render :nothing => true }
      format.xml  { head :ok }
    end
  end

end
