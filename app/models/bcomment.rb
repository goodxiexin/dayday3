class Bcomment < ActiveRecord::Base

  belongs_to :user

  belongs_to :blog,
             :counter_cache => :comments_count

end
