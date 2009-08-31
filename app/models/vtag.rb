class Vtag < ActiveRecord::Base

  belongs_to :user

  belongs_to :tagged_user,
             :class_name => 'User',
             :foreign_key => 'tagged_user_id'

  belongs_to :video,
             :counter_cache => 'tags_count'

  has_many :tag_notifications,
           :as => 'tag',
           :dependent => :destroy


end
