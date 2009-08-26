module UsersHelper

  def icon_path(user, size="small")
    if user.current_icon.blank?
      "default_#{size}.png"
    else
      user.current_icon.public_filename(size)
    end
  end

  def user_icon(user, size="small")
    if user.current_icon.blank?
      link_to image_tag("default_#{size}.png"), user_personal_url(user), :popup => true
    else
      link_to image_tag(user.current_icon.public_filename(size)), user_personal_url(user), :popup => true
    end
  end

  def link_to_user(user)
    link_to user.login, user_personal_url(user), :popup => true
  end

end
