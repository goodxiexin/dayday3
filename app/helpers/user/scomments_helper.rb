module User::ScommentsHelper

  def scomment_viewable(scomment, current_user)
    !scomment.whisper || (scomment.whisper and (current_user == scomment.user or current_user == scomment.receiver or current_user == scomment.status.user))
  end


end
