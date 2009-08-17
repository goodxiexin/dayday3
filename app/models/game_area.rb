class GameArea < ActiveRecord::Base

  # each game area belongs to a game
  belongs_to :game

  # each game area has many game servers
  has_many :servers,
           :class_name => 'GameServer',
           :foreign_key => 'area_id'  

end
