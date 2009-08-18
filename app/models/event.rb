class Event < ActiveRecord::Base
  # the poster of this activity
  belongs_to :poster,
             :class_name => 'User'

  # the category of this activity
  belongs_to :game

  # the location of the activity
  belongs_to :game_server

  # teh wall messages for a event
  has_many :event_wall_messages,
           :dependent => :destroy,
           :finder_sql => 'select event_wall_messages.* from event_wall_messages where event_wall_messages.user_id = #{id} OR event_wall_messages.receiver_id = #{id} ORDER BY created_at DESC'

  # participants of this activity
  has_many :participations,
           :dependent => :destroy
  has_many :participants,
           :through => :participations

  # others can comment your activity
  has_many :comments,
           :as => 'resource'

  # register the activity
  def register(user_id)
    user = User.find(user_id)
    if user
      self.participants << user
    end
  end

  # unregister the activity
  def unregister(user_id)
    user = self.participants.find(user_id)
    if user
      self.participants.delete(user)
    end
  end

  # cancel this activity
  # this action is only allowed for the poster of this activity
  def cancel(user_id)
    if poster?(user_id)
      self.destroy
    end
  end

  private
  # if the user is the poster of this activity
  def poster?(user_id)
    (poster_id == user_id)? true : false
  end
end
