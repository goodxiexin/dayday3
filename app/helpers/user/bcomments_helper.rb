module User::BcommentsHelper

  # if current user is blog owner, or the receiver of this bcomment, or the poster of this bcomment
  # then it's viewable
  def bcomment_viewable(bcomment, current_user)
    !bcomment.whisper || (bcomment.whisper and (current_user == bcomment.user or current_user == bcomment.receiver or current_user == bcomment.blog.user))
  end

end
