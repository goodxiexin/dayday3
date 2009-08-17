module MailboxesHelper

  def mail_select_tag
    select_tag 'select', options_for_select([['---', '^_^'], ['all','all'], ['read', 'read'], ['unread', 'unread'], ['none', 'none']], "---"), :onchange => "select_dropdown_onchange(this)"
  end

  def get_receiver(mail)
    (mail.receiver == current_user)? mail.sender : mail.receiver
  end

end
