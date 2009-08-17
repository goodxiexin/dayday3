class GameRacesController < ApplicationController

  layout 'admin'

  before_filter :check_administrator_role

  # GET /game_races
  # GET /game_races.xml
  def index
    @game_races = GameRaces.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @game_races }
    end
  end

  # GET /game_races/1
  # GET /game_races/1.xml
  def show
    @game_races = GameRaces.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game_races }
    end
  end

  # GET /game_races/new
  # GET /game_races/new.xml
  def new
    @game_races = GameRaces.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game_races }
    end
  end

  # GET /game_races/1/edit
  def edit
    @game_races = GameRaces.find(params[:id])
  end

  # POST /game_races
  # POST /game_races.xml
  def create
    @game_races = GameRaces.new(params[:game_races])

    respond_to do |format|
      if @game_races.save
        flash[:notice] = 'GameRaces was successfully created.'
        format.html { redirect_to(@game_races) }
        format.xml  { render :xml => @game_races, :status => :created, :location => @game_races }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game_races.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /game_races/1
  # PUT /game_races/1.xml
  def update
    @game_races = GameRaces.find(params[:id])

    respond_to do |format|
      if @game_races.update_attributes(params[:game_races])
        flash[:notice] = 'GameRaces was successfully updated.'
        format.html { redirect_to(@game_races) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game_races.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /game_races/1
  # DELETE /game_races/1.xml
  def destroy
    @game_races = GameRaces.find(params[:id])
    @game_races.destroy

    respond_to do |format|
      format.html { redirect_to(game_races_url) }
      format.xml  { head :ok }
    end
  end
end
