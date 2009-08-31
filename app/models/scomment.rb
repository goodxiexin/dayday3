class Scomment < ActiveRecord::Base

  belongs_to :user

  belongs_to :receiver,
             :class_name => 'User'

  belongs_to :status,
             :counter_cache => :comments_count

  has_many :comment_notifications,
           :as => 'comment',
           :dependent => :destroy

  def self.find_user_viewable(user_id, *args)
    with_user_viewable(user_id) {
      find(*args)
    }
  end

  def self.with_creation_order
    with_scope(:find => {:order => "created_at DESC"}) do
      yield
    end
  end

  def self.with_user_viewable(user_id)
    with_creation_order do
      with_scope(:find => {:conditions => ["whisper = 0 OR user_id = ? OR receiver_id = ?", user_id, user_id]}) do
        yield
      end
    end
  end

end
