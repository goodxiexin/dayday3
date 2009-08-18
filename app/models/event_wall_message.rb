class EventWallMessage < ActiveRecord::Base
  
  belongs_to :event

  belongs_to :poster,
             :class_name => 'User'
             :foreign_key => 'poster_id'
end
