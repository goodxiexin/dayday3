class User::FriendGuessesController < ApplicationController
  layout 'friend'
  
  before_filter :login_required

  def index
    @user = current_user
    # currently friend guesses are created everytimes when user view friend guesses page
    # In future, this need to be modified to release server load
    @user.create_friend_guesses
    @friend_suggestions = current_user.guessed_friends.sort_by{rand}[0..8]
    @common_game_characters = {}
    # this prevent multiple game characters in one game server
    current_user.currently_playing_game_characters.each do |game_character|
      @current_game_characters = {}
      @current_game_characters.default = ' ' 
      game_character.server.game_characters.each do |other_character|
        @current_game_characters[other_character.user.id] += (other_character.name + ' ')
      end
      @common_game_characters[game_character.server.id] = @current_game_characters
    end
  end

  def show_all
    @server = GameServer.find(params[:server_id])
    @current_game_characters={}
    @current_game_characters.default = ' '
    @server.game_characters.each do |other_character|
      @current_game_characters[other_character.user.id] += (other_character.name + ' ')
    end
    # currently the users are shown with login order (user.id),but login name ASC order is perfered
    @temp_array = @current_game_characters.sort
    @user_array = @temp_array.paginate :page => params[:page], :per_page => 10
  end

  def show_all_server_characters
    @user = current_user
    @common_game_characters={}
    current_user.game_characters.each do |game_character|
      @current_game_characters = {}
      @current_game_characters.default = ' '
      game_character.server.game_characters.each do |other_character|
        @current_game_characters[other_character.user.id] += (other_character.name + ' ')
      end
      @common_game_characters[game_character.server.id] = @current_game_characters
    end
  end
end
