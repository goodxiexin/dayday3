class User::CharactersController < ApplicationController

  before_filter :login_required

  before_filter :owner_required, :only => [:new, :edit, :create, :update, :confirm_destroy, :destroy]

  def new
    @user = resource_owner
    @games = Game.all
  end

  def show
    @user = resource_owner
    @character = @user.game_characters.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :text => 'character not found'
  end

  def edit
    @user = resource_owner
    @character = @user.game_characters.find(params[:id])
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
  rescue ActiveRecord::RecordNotFound
    render :text => 'character not found'
  end

  def create
    @user = resource_owner
    @character = GameCharacter.new(params[:character])
    @character.user = @user
    if @character.save
      render :update do |page|
        page.insert_html :bottom, 'characters', :partial => 'character', :object => @character
        page << "facebox.close(); facebox.watchClickEvents();"
      end
    else
      render :update do |page|
        page << "facebox.show_error('There was an error creating this character');"
      end
    end
  end

  def update
    @user = resource_owner
    @character = @user.game_characters.find(params[:id])
    if @character.update_attributes(params[:character])
      render :update do |page|
        page << "facebox.close();$('character_#{@character.id}').innerHTML = '#{@character.name}'"
      end
    else
      render :update do |page|
        page << "facebox.show_error('THere was an error updating your character');"
      end
    end 
  rescue ActiveRecord::RecordNotFound
    render :text => 'character not found'
  end

  def confirm_destroy
    @user = resource_owner
    @character = @user.game_characters.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render :text => 'character not found'
  end

  def destroy
    @user = resource_owner
    if(session[:validation_text] == params[:validation_text])
      @character = @user.game_characters.find(params[:id])
      @character.destroy
      render :update do |page|
        page << "facebox.close();$('character_#{@character.id}').parentNode.remove();"
      end
    else
      render :update do |page|
        page << "facebox.show_error('incorrect validation code')"
      end
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'character not found' 
  end

end
