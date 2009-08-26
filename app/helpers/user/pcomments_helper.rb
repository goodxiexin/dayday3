module User::PcommentsHelper

  def pcomment_viewable(pcomment, current_user)
    !pcomment.whisper || (pcomment.whisper and (current_user == pcomment.user or current_user == pcomment.receiver or current_user == pcomment.photo.album.user))
  end


end
