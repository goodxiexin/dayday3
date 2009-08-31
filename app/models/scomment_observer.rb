class ScommentObserver < ActiveRecord::Observer

  def after_save(comment)
    CommentNotification.create(:user_id => comment.receiver_id, :comment_id => comment.id, :comment_type => 'Scomment')
    setting = comment.receiver.mail_setting
    status = comment.status
    if status.user_id == comment.receiver_id and comment.user_id != status.user_id
      StatusMailer.deliver_comment_to_status_owner(comment)
    else
      if setting.comment_my_status and !comment.whisper and comment.user_id != status.user_id
        StatusMailer.deliver_comment_to_status_owner(comment)
      end
      if setting.comment_same_status_after_me
        StatusMailer.deliver_comment_to_receiver(comment)
      end
    end
  end
 
end
