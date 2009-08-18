class GameServersController < ApplicationController

  layout 'admin'

  before_filter :check_administrator_role

  # GET /game_servers
  # GET /game_servers.xml
  def index
    @game_servers = GameServer.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @game_servers }
    end
  end

  # GET /game_servers/1
  # GET /game_servers/1.xml
  def show
    @game_server = GameServer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game_server }
    end
  end

  # GET /game_servers/new
  # GET /game_servers/new.xml
  def new
    @game_server = GameServer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game_server }
    end
  end

  # GET /game_servers/1/edit
  def edit
    @game_server = GameServer.find(params[:id])
  end

  # POST /game_servers
  # POST /game_servers.xml
  def create
    @game_server = GameServer.new(params[:game_server])

    respond_to do |format|
      if @game_server.save
        flash[:notice] = 'GameServer was successfully created.'
        format.html { redirect_to(@game_server) }
        format.xml  { render :xml => @game_server, :status => :created, :location => @game_server }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game_server.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /game_servers/1
  # PUT /game_servers/1.xml
  def update
    @game_server = GameServer.find(params[:id])

    respond_to do |format|
      if @game_server.update_attributes(params[:game_server])
        flash[:notice] = 'GameServer was successfully updated.'
        format.html { redirect_to(@game_server) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game_server.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /game_servers/1
  # DELETE /game_servers/1.xml
  def destroy
    @game_server = GameServer.find(params[:id])
    @game_server.destroy

    respond_to do |format|
      format.html { redirect_to(game_servers_url) }
      format.xml  { head :ok }
    end
  end
end
