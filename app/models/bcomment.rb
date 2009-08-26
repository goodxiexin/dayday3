class Bcomment < ActiveRecord::Base

  belongs_to :user # who posted this comment

  belongs_to :receiver # who did user reply to

  belongs_to :blog,
             :counter_cache => :comments_count

  has_one :bcomment_notification,
          :dependent => :destroy

end
