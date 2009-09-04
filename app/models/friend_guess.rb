class FriendGuess < ActiveRecord::Base
  belongs_to :user

  belongs_to :guessed_friend,
             :class_name => 'User',
             :foreign_key => 'guess_id'

end
