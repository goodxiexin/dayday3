class Btag < ActiveRecord::Base

  belongs_to :user

  belongs_to :tagged_user,
             :class_name => 'User',
             :foreign_key => 'tagged_user_id'

  belongs_to :blog,
             :counter_cache => 'tags_count'

end
