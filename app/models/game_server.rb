class GameServer < ActiveRecord::Base

  belongs_to :game
  belongs_to :area

  has_many :game_characters,
           :foreign_key => 'server_id'

end
