class PhotoObserver < ActiveRecord::Observer

  def after_save(photo)
    photo.album.update_attribute('updated_at', Time.now) unless photo.album.blank?
  end

end
