class CommentObserver < ActiveRecord::Observer

  observe :Bcomment, :Vcomment, :Scomment, :Pcomment

  def after_save(comment)
    notification_name = comment.class.to_s.concat "Notification"
    eval("#{notification_name}").create(:user_id => comment.receiver_id, :comment_id => comment.id)
  end

end
