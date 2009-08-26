class Game < ActiveRecord::Base

  # each game has multiple servers
  has_many :servers,
           :class_name => 'GameServer',
           :dependent => :destroy
  
  # each game has multiple game areas
  # some games has only servers but no areas, in this case, areas has no elements
  has_many :areas,
           :class_name => 'GameArea',
           :dependent => :destroy

  # each game has multiple professions and races
  has_many :professions,
           :class_name => 'GameProfession',
           :dependent => :destroy

  has_many :races,
           :class_name => 'GameRace',
           :dependent => :destroy

  has_many :blogs,
           :order => 'digs_count DESC'

  has_many :videos,
           :order => 'digs_count DESC'

  has_many :photos,
           :order => 'digs_count DESC'  

end
