class FriendRequestMailer < ActionMailer::Base
  
  def friend_request(friend_request)
    setup_email(friend_request)
    @recipients = friend_request.receiver.email
    @subject += "你有新的好友请求"
    @body[:url] = "http://localhost:3000/users/#{friend_request.receiver.id}/friend_requests"    
  end

  def accepted_friend_request(friend_request)
    setup_email(friend_request)
    @recipients = friend_request.sender.email
    @subject += "你的好友请求被接受"
    @body[:url] = "http://localhost:3000/users/#{friend_request.receiver_id}/personal" 
  end

  def declined_friend_request(friend_request)
    setup_email(friend_request)
    @recipients = friend_request.sender.email
    @subject += "你的好友请求被拒绝" 
  end

protected
  def setup_email(friend_request)
    @from = "gaoxh04@gmail.com"
    @subject = "Dayday3 - "
    @sent_on = Time.now
    @body[:request] = friend_request
  end

end
