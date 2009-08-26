class Bcomment < ActiveRecord::Base

  belongs_to :user # who posted this comment

  belongs_to :receiver, # who did user reply to
             :class_name => 'User'

  belongs_to :blog,
             :counter_cache => :comments_count

  has_one :bcomment_notification,
          :foreign_key => 'comment_id',
          :dependent => :destroy

end
