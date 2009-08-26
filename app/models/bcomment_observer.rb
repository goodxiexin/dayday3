class BcommentObserver < ActiveRecord::Observer

  # after a bcomment is created, send a notification to the receiver
  # receiver might be the owner of the resource or someone who commented this resource
  def after_save(bcomment)
    notification = BcommentNotification.create(
	:user_id => current_user.id,
	:receiver_id => bcomment.receiver_id,
	:blog_id => bcomment.blog.id)
  end

end
