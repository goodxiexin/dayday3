class GameServer < ActiveRecord::Base

  belongs_to :game
  belongs_to :area

end
