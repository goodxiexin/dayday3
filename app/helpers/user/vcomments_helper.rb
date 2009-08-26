module User::VcommentsHelper

  def vcomment_viewable(vcomment, current_user)
    !vcomment.whisper || (vcomment.whisper and (current_user == vcomment.user or current_user == vcomment.receiver or current_user == vcomment.video.user))
  end


end
