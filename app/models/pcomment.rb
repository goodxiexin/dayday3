class Pcomment < ActiveRecord::Base

  belongs_to :user

  belongs_to :photo,
             :counter_cache => 'comments_count'

end
