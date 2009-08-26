# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def ftime(time)
    time.strftime("%Y-%m-%d %H:%M") unless time.blank?
  end

  def ftime2(time)
    time.strftime("%Y-%m-%d") unless time.blank?
  end

  def ftime3(time)
    time.strftime("%m-%d") unless time.blank?
  end

  def ftime4(time)
    time.strftime("%H: %M") unless time.blank?
  end

  def validation_image
    "<img src='/application/new_validation_image' />"
  end

  def privilege_select_tag(resource, privilege)
    select_tag "#{resource}[privilege]", options_for_select([['all', 'all'], ['friends', 'friends'], ['myself', 'myself']], privilege)
  end

  def link_to_game(game)
    link_to game.name
  end

end
