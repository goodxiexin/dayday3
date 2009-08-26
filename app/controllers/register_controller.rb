class RegisterController < ApplicationController

  def new_character
    @character = GameCharacter.new
    @games = Game.all
  end

  def edit_character
    @character = GameCharacter.new(params[:character])
    @games = Game.all
    @game = @character.game
    if @game.no_areas
      @servers = @game.servers
    else
      @areas = @game.areas
      @servers = @character.area.servers
    end
    @races = @game.races
    @professions = @game.professions
  end

  def game_details
    @game = Game.find(params[:game_id])
    if @game.no_areas
      @servers = @game.servers
    else
      @areas = @game.areas
      @servers = []
    end
    @races = @game.races
    @professions = @game.professions
    render :partial => 'game_details' 
  end

  def area_details
    @game_area = GameArea.find(params[:area_id])
    @servers = @game_area.servers
    render :partial => 'user/characters/server_select', :locals => {:servers => @servers, :server_id => nil}
  end

end
