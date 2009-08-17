class GameCharacter < ActiveRecord::Base

  # a user has multiple game characters
  belongs_to :user

  # which game?
  belongs_to :game

  # which area?
  # if the game has no areas but only servers, this field is null
  belongs_to :area,
             :class_name => 'GameArea',
             :foreign_key => 'area_id'

  # which server
  belongs_to :server,
             :class_name => 'GameServer',
             :foreign_key => 'server_id'

  # which race
  belongs_to :race,
             :class_name => 'GameRace',
             :foreign_key => 'race_id'

  # which profession
  belongs_to :profession,
             :class_name => 'GameProfession',
             :foreign_key => 'profession_id'

end
