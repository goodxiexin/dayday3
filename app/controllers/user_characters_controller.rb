class UserCharactersController < ApplicationController

  before_filter :login_required

  def new
    @user = User.find(params[:user_id])
    @games = Game.all
  end

  def edit
    @user = User.find(params[:user_id])
    @character = @user.game_characters.find(params[:id])
    @games = Game.all
    @game = @character.game
    @servers = @game.servers
    @areas = @game.areas unless @game.no_areas   
    @races = @game.races
    @professions = @game.professions
  end

  def create
    @user = User.find(params[:user_id])
    @character = GameCharacter.new(params[:character])
    @character.user = @user
    if @character.save
      render :update do |page|
        page.insert_html :bottom, 'characters', :partial => 'character', :object => @character
        page << "facebox.close(); facebox.watchClickEvents();"
      end
    else
      render :update do |page|
        page << "$('error').innerHTML = 'There was an error creating this character'"
      end
    end
  end

  def update
    @user = User.find(params[:user_id])
    @character = @user.game_characters.find(params[:id])
    if @character.update_attributes(params[:character])
      render :update do |page|
        page << "facebox.close();$('character_#{@character.id}').innerHTML = '#{@character.name}'"
      end
    else
      render :update do |page|
        page << "$('error').innerHTML = 'THere was an error updating your character'"
      end
    end 
  end

  def confirm_destroy
    @user = User.find(params[:user_id])
    @character = @user.game_characters.find(params[:id])
  end

  def destroy
    @user = User.find(params[:user_id])
    
    if(session[:validation_text] == params[:validation_text])
      @character = @user.game_characters.find(params[:id])
      @character.destroy
      render :update do |page|
        page << "facebox.close();$('character_#{@character.id}').parentNode.remove();"
      end
    else
      render :update do |page|
        page << "$('error').innerHTML = 'incorrect validation code'"
      end
    end 
  end

end
