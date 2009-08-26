class BcommentNotification < ActiveRecord::Base

  belongs_to :user

  belongs_to :comment,
             :class_name => 'Bcomment'

end

