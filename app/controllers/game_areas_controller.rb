class GameAreasController < ApplicationController

  # GET /game_areas
  # GET /game_areas.xml
  def index
    @game_areas = GameArea.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @game_areas }
    end
  end

  # GET /game_areas/1
  # GET /game_areas/1.xml
  def show
    @is_show = params[:show]
    @game_area = GameArea.find(params[:id])
    @servers = @game_area.servers

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game_area }
    end
  end

  # GET /game_areas/new
  # GET /game_areas/new.xml
  def new
    @game_area = GameArea.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game_area }
    end
  end

  # GET /game_areas/1/edit
  def edit
    @game_area = GameArea.find(params[:id])
  end

  # POST /game_areas
  # POST /game_areas.xml
  def create
    @game_area = GameArea.new(params[:game_area])

    respond_to do |format|
      if @game_area.save
        flash[:notice] = 'GameArea was successfully created.'
        format.html { redirect_to(@game_area) }
        format.xml  { render :xml => @game_area, :status => :created, :location => @game_area }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game_area.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /game_areas/1
  # PUT /game_areas/1.xml
  def update
    @game_area = GameArea.find(params[:id])

    respond_to do |format|
      if @game_area.update_attributes(params[:game_area])
        flash[:notice] = 'GameArea was successfully updated.'
        format.html { redirect_to(@game_area) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game_area.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /game_areas/1
  # DELETE /game_areas/1.xml
  def destroy
    @game_area = GameArea.find(params[:id])
    @game_area.destroy

    respond_to do |format|
      format.html { redirect_to(game_areas_url) }
      format.xml  { head :ok }
    end
  end
end
