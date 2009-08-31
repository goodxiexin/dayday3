class CommentObserver < ActiveRecord::Observer

  observe :Bcomment, :Vcomment, :Scomment, :Pcomment

  def after_save(comment)
    CommentNotification.create(:user_id => comment.receiver_id, :comment_id => comment.id, :comment_type => comment.class.to_s)
  end

end
