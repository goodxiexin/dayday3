class VtagObserver < ActiveRecord::Observer

  def after_save(tag)
    TagNotification.create(:user_id => tag.tagged_user_id, :tag_id => tag.id, :tag_type => 'Vtag')
    setting = tag.tagged_user.mail_setting
    if setting.tag_me_in_video
      VideoMailer.deliver_tag_to_receiver(tag)
    end 
  end

end
