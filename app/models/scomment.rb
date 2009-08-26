class Scomment < ActiveRecord::Base

  belongs_to :user

  belongs_to :receiver

  belongs_to :status,
             :counter_cache => :comments_count

end
