class FriendRequest < ActiveRecord::Base

  belongs_to :sender,
             :class_name => 'User'

  belongs_to :receiver,
             :class_name => 'User'

  def accept
    @accepted = true
  end

  def decline
    @declined = true
  end

  def recently_accepted?
    @accepted
  end

  def recently_declined?
    @declined
  end

end
