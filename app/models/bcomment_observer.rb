class BcommentObserver < ActiveRecord::Observer

  def after_save(comment)
    CommentNotification.create(:user_id => comment.receiver_id, :comment_id => comment.id, :comment_type => 'Bcomment')
    setting = comment.receiver.mail_setting
    blog = comment.blog
    if blog.user_id == comment.receiver_id and blog.user_id != comment.user_id
      BlogMailer.deliver_comment_to_blog_owner(comment)
    else
      if setting.comment_my_blog and !comment.whisper and blog.user_id != comment.user_id
        BlogMailer.deliver_comment_to_blog_owner(comment)
      end
      if setting.comment_same_blog_after_me
        BlogMailer.deliver_comment_to_receiver(comment)
      end
    end
    # send email to all tagged users except photo owner, comment sender and comment receiver in this photo
    tagged_users = blog.tags.map { |tag| tag.tagged_user }.uniq
    tagged_users.each do |tagged_user|
      if !comment.whisper and tagged_user.id != comment.receiver_id and tagged_user.id != blog.user_id and tagged_user.id != comment.user_id and tagged_user.mail_setting.comment_blog_contains_me
        CommentNotification.create(:user_id => tagged_user.id, :comment_id => comment.id, :comment_type => 'Bcomment')
        BlogMailer.deliver_comment_to_tagged_user(comment, tagged_user)
      end
    end
  end 

end
