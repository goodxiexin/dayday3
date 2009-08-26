class Scomment < ActiveRecord::Base

  belongs_to :user

  belongs_to :receiver,
             :class_name => 'User'

  belongs_to :status,
             :counter_cache => :comments_count

end
