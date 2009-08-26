class Vcomment < ActiveRecord::Base

  belongs_to :user

  belongs_to :receiver,
             :class_name => 'User'

  belongs_to :video,
             :counter_cache => :comments_count


end
