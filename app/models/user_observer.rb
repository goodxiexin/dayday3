class UserObserver < ActiveRecord::Observer

  def after_create(user)
    PrivacySetting.create(:user_id => user.id)
    MailSetting.create(:user_id => user.id)
    UserMailer.deliver_signup_notification(user)
  end

  def after_save(user)
    UserMailer.deliver_activation(user) if user.recently_activated?
    UserMailer.deliver_forgot_password(user) if user.recently_forgot_password?
    UserMailer.deliver_reset_password(user) if user.recently_reset_password?
  end

end
