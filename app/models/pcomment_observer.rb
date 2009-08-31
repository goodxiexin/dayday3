class PcommentObserver < ActiveRecord::Observer

  def after_save(comment)
    CommentNotification.create(:user_id => comment.receiver_id, :comment_id => comment.id, :comment_type => 'Pcomment')
    setting = comment.receiver.mail_setting
    photo = comment.photo
    album = photo.album
    # send email to photo owner and receiver
    if album.user_id == comment.receiver_id and comment.user_id != album.user_id
      PhotoMailer.deliver_comment_to_photo_owner(comment)
    else
      if setting.comment_my_photo and !comment.whisper and comment.user_id != album.user_id
        PhotoMailer.deliver_comment_to_photo_owner(comment)
      end
      if setting.comment_same_photo_after_me
        PhotoMailer.deliver_comment_to_receiver(comment)
      end
    end
    # send email to all tagged users except photo owner, comment sender and comment receiver in this photo
    tagged_users = photo.tags.map { |tag| tag.tagged_user }.uniq
    tagged_users.each do |tagged_user|
      if !comment.whisper and tagged_user.id != comment.receiver_id and tagged_user.id != album.user_id and tagged_user.id != comment.user_id and tagged_user.mail_setting.comment_photo_contains_me
        CommentNotification.create(:user_id => tagged_user.id, :comment_id => comment.id, :comment_type => 'Pcomment')
        PhotoMailer.deliver_comment_to_tagged_user(comment, tagged_user)
      end
    end
  end 

end
