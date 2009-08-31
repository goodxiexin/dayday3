class FriendRequestObserver < ActiveRecord::Observer

  def after_create(friend_request)
    FriendRequestMailer.deliver_friend_request(friend_request)
    FriendNotification.create(:user_id => friend_request.receiver_id, :sender_id => friend_request.sender_id, :content => 'request')
  end

  def after_destroy(friend_request)
    if friend_request.recently_accepted?
      FriendRequestMailer.deliver_accepted_friend_request(friend_request)
      FriendNotification.create(:user_id => friend_request.sender_id, :sender_id => friend_request.receiver_id, :content => 'accept')
    end
    if friend_request.recently_declined?
      FriendRequestMailer.deliver_declined_friend_request(friend_request)
      FriendNotification.create(:user_id => friend_request.sender_id, :sender_id => friend_request.receiver_id, :content => 'decline')
    end
  end

end
