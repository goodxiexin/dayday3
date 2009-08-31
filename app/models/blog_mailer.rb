class BlogMailer < ActionMailer::Base

  def comment_to_blog_owner(comment)
    setup_comment_email(comment)
    @recipients = @owner.email
    @subject = "#{@commentor.login} 在你的博客#{@blog.title[0..20]}里留言了"
    @body[:url] = "http://localhost:3000/users/#{@owner.id}/blogs/#{@blog.id}"
  end

  def comment_to_receiver(comment)
    setup_comment_email(comment)
    @recipients = @receiver.email
    @subject = "#{@commentor.login} 在博客#{@blog.title[0..20]}里留言了"
    @body[:url] = "http://localhost:3000/users/#{@owner.id}/blogs/#{@blog.id}"
  end

  def comment_to_tagged_user(comment, tagged_user)
    setup_comment_email(comment)
    @tagged_user = tagged_user
    @recipients = @tagged_user.email
    @subject = "#{comment.user.login} 在博客#{@blog.title[0..20]}里留言了"
    @body[:url] = "http://localhost:3000/users/#{@owner.id}/blogs/#{@blog.id}"
  end


  def tag_to_receiver(tag)
    setup_tag_email(tag)
    @recipients = @tagged_user.email
    @subject = "#{@user.login} 在博客#{@blog.title[0..20]}里标记了你"
    @body[:url] = "http://localhost:3000/users/#{@blog.user_id}/blogs/#{@blog.id}"
  end

protected

  def setup_comment_email(comment)
    @blog = comment.blog
    @owner = @blog.user
    @commentor = comment.user
    @receiver = comment.receiver
    @from = "gaoxh04@gmail.com"
    @subject = "Dayday3 - "
    @sent_on = Time.now
    @body[:comment] = comment
  end

  def setup_tag_email(tag)
    @blog = tag.blog
    @tagged_user = tag.tagged_user
    @user = tag.user
    @from = "gaoxh04@gmail.com"
    @subject = "Dayday3 - "
    @sent_on = Time.now
    @body[:tag] = tag
  end

end
