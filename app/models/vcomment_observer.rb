class VcommentObserver < ActiveRecord::Observer

  def after_save(comment)
    CommentNotification.create(:user_id => comment.receiver_id, :comment_id => comment.id, :comment_type => 'Vcomment')
    setting = comment.receiver.mail_setting
    video = comment.video
    if video.user_id == comment.receiver_id and video.user_id != comment.user_id
      VideoMailer.deliver_comment_to_video_owner(comment)
    else
      if setting.comment_my_video and !comment.whisper and video.user_id != comment.user_id
        VideoMailer.deliver_comment_to_video_owner(comment)
      end
      if setting.comment_same_video_after_me
        VideoMailer.deliver_comment_to_receiver(comment)
      end
    end
    # send email to all tagged users except photo owner, comment sender and comment receiver in this photo
    tagged_users = video.tags.map { |tag| tag.tagged_user }.uniq
    tagged_users.each do |tagged_user|
      if !comment.whisper and tagged_user.id != comment.receiver_id and tagged_user.id != video.user_id and tagged_user.id != comment.user_id and tagged_user.mail_setting.comment_video_contains_me
        CommentNotification.create(:user_id => tagged_user.id, :comment_id => comment.id, :comment_type => 'Vcomment')
        VideoMailer.deliver_comment_to_tagged_user(comment, tagged_user)
      end
    end
  end
 
end
