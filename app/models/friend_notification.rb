class FriendNotification < ActiveRecord::Base

  belongs_to :sender,
             :foreign_key => 'User'

  belongs_to :user

end
