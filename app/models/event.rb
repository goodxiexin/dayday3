class Event < ActiveRecord::Base
  # the poster of this activity
  belongs_to :poster,
             :class_name => 'User'

  # the category of this activity
  belongs_to :game

  # the location of the activity
  belongs_to :game_server

  # the album for the event, one-one relation
  belongs_to :album

  # the wall messages for a event
  has_many :event_wall_messages,
           :dependent => :destroy,
           :finder_sql => 'select event_wall_messages.* from event_wall_messages where event_wall_messages.event_id = #{id} ORDER BY created_at DESC'

  # participants of this activity
  has_many :participations,
           :dependent => :destroy
  has_many :requests,
           :class_name => 'Participation',
           :conditions => 'event_status = 0',
           :dependent => :destroy
  has_many :invitee_participations,
           :class_name => 'Participation',                                   
           :conditions => 'event_status = 1',
           :dependent => :destroy
  has_many :refuser_participations,
           :class_name => 'Participation',                                   
           :conditions => 'event_status = 2',
           :dependent => :destroy
  has_many :maybe_attender_participations,
           :class_name => 'Participation',
           :conditions => 'event_status = 3',
           :dependent => :destroy
  has_many :must_attender_participations,
           :class_name => 'Participation',                                 
           :conditions => 'event_status = 4',
           :dependent => :destroy
  has_many :participants,
           :uniq => true,
           :through => :participations  
  has_many :requesters,
           :conditions => 'event_status = 0',
           :through => :participations
  has_many :invitees,
           :conditions => 'event_status = 1',
           :through => :participations
  has_many :refusers,
           :conditions => 'event_status = 2',
           :through => :participations
  has_many :maybe_attenders,
           :conditions => 'event_status = 3',
           :through => :participations
  has_many :must_attenders,
           :conditions => 'event_status = 4',
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
