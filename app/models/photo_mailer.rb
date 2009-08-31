class PhotoMailer < ActionMailer::Base

  def comment_to_photo_owner(comment)
    setup_comment_email(comment)
    @recipients = @owner.email
    @subject = "#{@commentor.login} 在你的相册#{@album.title[0..20]}里留言了"
    @body[:url] = "http://localhost:3000/albums/#{@album.id}/photos/#{@photo.id}"
  end

  def comment_to_receiver(comment)
    setup_comment_email(comment)
    @recipients = @receiver.email
    @subject = "#{@commentor.login} 在相册#{@album.title[0..20]}里给你留言了"
    @body[:url] = "http://localhost:3000/albums/#{@album.id}/photos/#{@photo.id}"
  end

  def comment_to_tagged_user(comment, tagged_user)
    setup_comment_email(comment)
    @tagged_user = tagged_user
    @recipients = @tagged_user.email
    @subject = "#{comment.user.login} 在相册#{@album.title[0..20]}里留言了"
    @body[:url] = "http://localhost:3000/albums/#{@album.id}/photos/#{@photo.id}"
  end

  def tag_to_receiver(tag)
    setup_tag_email(tag)
    @recipients = @tagged_user.email
    @subject = "#{@user.login} 在相册#{@album.title[0..20]}里圈了你"
    @body[:url] = "http://localhost:3000/albums/#{@album.id}/photos/#{@photo.id}"
  end

  def tag_to_photo_owner(tag)
    setup_tag_email(tag)
    @recipients = @owner.email
    @subject = "#{@user.login} 在你的相册#{@album.title[0..20]}里圈了#{@tagged_user.login}"
    @body[:url] = "http://localhost:3000/albums/#{@album.id}/photos/#{@photo.id}"
  end

protected

  def setup_comment_email(comment)
    @photo = comment.photo
    @album = @photo.album
    @owner = @album.user
    @commentor = comment.user
    @receiver = comment.receiver
    @from = "gaoxh04@gmail.com"
    @subject = "Dayday3 - "
    @sent_on = Time.now
    @body[:comment] = comment
  end

  def setup_tag_email(tag)
    @photo = tag.photo
    @album = @photo.album
    @owner = @album.user
    @tagged_user = tag.tagged_user
    @user = tag.user
    @from = "gaoxh04@gmail.com"
    @subject = "Dayday3 - "
    @sent_on = Time.now
    @body[:tag] = tag
  end

end
