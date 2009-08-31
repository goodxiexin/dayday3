class PtagObserver < ActiveRecord::Observer

  def after_save(tag)
    TagNotification.create(:user_id => tag.tagged_user_id, :tag_id => tag.id, :tag_type => tag.class.to_s)
    setting = tag.tagged_user.mail_setting
    photo = tag.photo
    album = photo.album
    if setting.tag_me_in_photo
      PhotoMailer.deliver_tag_to_receiver(tag)
    end
    if setting.tag_my_photo and album.user_id != tag.tagged_user_id
      PhotoMailer.deliver_tag_to_photo_owner(tag)
    end 
  end

end
