module UsersHelper

  def user_icon(user, size="small")
    if user.current_icon.blank?
      link_to image_tag("default_#{size}.png"), user_url(user), :popup => true
    else
      link_to image_tag(user.current_icon.public_filename(size)), user_url(user), :popup => true
    end
  end

  def link_to_user(user)
    link_to user.login, user_url(user), :popup => true
  end

end
