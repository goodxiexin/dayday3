class GameProfessionsController < ApplicationController
  
  layout 'admin'

  before_filter :check_administrator_role

  # GET /game_professions
  # GET /game_professions.xml
  def index
    @game_professions = GameProfession.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @game_professions }
    end
  end

  # GET /game_professions/1
  # GET /game_professions/1.xml
  def show
    @game_profession = GameProfession.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game_profession }
    end
  end

  # GET /game_professions/new
  # GET /game_professions/new.xml
  def new
    @game_profession = GameProfession.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game_profession }
    end
  end

  # GET /game_professions/1/edit
  def edit
    @game_profession = GameProfession.find(params[:id])
  end

  # POST /game_professions
  # POST /game_professions.xml
  def create
    @game_profession = GameProfession.new(params[:game_profession])

    respond_to do |format|
      if @game_profession.save
        flash[:notice] = 'GameProfession was successfully created.'
        format.html { redirect_to(@game_profession) }
        format.xml  { render :xml => @game_profession, :status => :created, :location => @game_profession }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game_profession.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /game_professions/1
  # PUT /game_professions/1.xml
  def update
    @game_profession = GameProfession.find(params[:id])

    respond_to do |format|
      if @game_profession.update_attributes(params[:game_profession])
        flash[:notice] = 'GameProfession was successfully updated.'
        format.html { redirect_to(@game_profession) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game_profession.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /game_professions/1
  # DELETE /game_professions/1.xml
  def destroy
    @game_profession = GameProfession.find(params[:id])
    @game_profession.destroy

    respond_to do |format|
      format.html { redirect_to(game_professions_url) }
      format.xml  { head :ok }
    end
  end
end
