class PcommentNotification < ActiveRecord::Base

  belongs_to :user

  belongs_to :commentor,
             :class_name => 'User'

  belongs_to :comment,
             :class_name => 'Pcomment'

end
