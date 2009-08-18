class EventsController < ApplicationController
  layout 'event'

  def index
  end

  def new
    @event = Event.new
    @games = Game.all
  end

  def show
  end

  def create
    @event = Event.new(params[:event])
    @event.save
    flash[:notice] = "Event is successfully created"
    redirect_to root_url
  end

  def update
  end

  def edit
  end

  def destroy
  end
end
