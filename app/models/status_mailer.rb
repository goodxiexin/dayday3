class StatusMailer < ActionMailer::Base

  def comment_to_status_owner(comment)
    setup_comment_email(comment)
    @recipients = @owner.email
    @subject = "#{@commentor.login} 在你的状态#{@status.content[0..20]}里留言了"
    @body[:url] = "http://localhost:3000/users/#{@owner.id}/statuses?status_id=#{@status.id}?"
  end

  def comment_to_receiver(comment)
    setup_comment_email(comment)
    @recipients = @receiver.email
    @subject = "#{@commentor.login} 在#{@owner.login}的状态#{@status.content[0..20]}里给你留言了"
    @body[:url] = "http://localhost:3000/users/#{@owner.id}/statuses?status_id=#{@status.id}"
  end

protected

  def setup_comment_email(comment)
    @status = comment.status
    @owner = @status.user
    @commentor = comment.user
    @receiver = comment.receiver
    @from = "gaoxh04@gmail.com"
    @subject = "Dayday3 - "
    @sent_on = Time.now
    @body[:comment] = comment
  end

end

