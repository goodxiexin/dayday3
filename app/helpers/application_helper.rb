# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def ftime(time)
    time.strftime("%Y-%m-%d %H:%M") unless time.blank?
  end

  def ftime2(time)
    time.strftime("%Y-%m-%d") unless time.blank?
  end


  def validation_image
    "<img src='/application/new_validation_image' />"
  end

end
