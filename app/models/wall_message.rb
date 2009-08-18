class WallMessage < ActiveRecord::Base

  belongs_to :user

  belongs_to :poster,
             :class_name => 'User',
             :foreign_key => 'poster_id'

end
