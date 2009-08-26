class BcommentNotification < ActiveRecord::Base 
  
  belongs_to :user

  belongs_to :commentor,
             :class_name => 'User',
             :foreign_key => 'commentor_id'

  belongs_to :blog

end
