class GameCharactersController < ApplicationController
  # GET /game_characters
  # GET /game_characters.xml
  def index
    @game_characters = GameCharacter.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @game_characters }
    end
  end

  # GET /game_characters/1
  # GET /game_characters/1.xml
  def show
    @game_characters = GameCharacters.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game_characters }
    end
  end

  def edit_new
    @game_character = GameCharacter.new(params[:character])
    @games = Game.all
    @game = @game_character.game
    if @game.no_areas
      @servers = @game.servers
    else
      @areas = @game.areas
      @servers = @character.area.servers
    end
    @races = @game.races
    @professions = @game.professions
  end

  # GET /game_characters/new
  # GET /game_characters/new.xml
  def new
    @game_character = GameCharacter.new
    @games = Game.all
    respond_to do |format|
      format.html
      format.xml  { render :xml => @game_character }
    end
  end

  # GET /game_characters/1/edit
  def edit
    @game_characters = GameCharacters.find(params[:id])
  end

  # POST /game_characters
  # POST /game_characters.xml
  def create
    @game_character = GameCharacter.new(params[:game_character])

    respond_to do |format|
      if @game_character.save
        flash[:notice] = 'GameCharacters was successfully created.'
        format.html { 
          render :update do |page|
            page.insert_html :bottom, 'characters', :partial => 'character', :object => @game_character
            page << "facebox.close();"
          end
        }
        format.xml  { render :xml => @game_characters, :status => :created, :location => @game_characters }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game_characters.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /game_characters/1
  # PUT /game_characters/1.xml
  def update
    @game_characters = GameCharacters.find(params[:id])

    respond_to do |format|
      if @game_characters.update_attributes(params[:game_characters])
        flash[:notice] = 'GameCharacters was successfully updated.'
        format.html { redirect_to(@game_characters) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game_characters.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /game_characters/1
  # DELETE /game_characters/1.xml
  def destroy
    @game_characters = GameCharacters.find(params[:id])
    @game_characters.destroy

    respond_to do |format|
      format.html { redirect_to(game_characters_url) }
      format.xml  { head :ok }
    end
  end
end
