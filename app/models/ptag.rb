class Ptag < ActiveRecord::Base

  belongs_to :user

  belongs_to :tagged_user,
             :class_name => 'User'
 
  belongs_to :photo,
             :counter_cache => 'tags_count'

  has_many :tag_notifications,
           :as => 'tag',
           :dependent => :destroy

end
