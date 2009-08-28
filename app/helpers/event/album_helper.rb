module Event::AlbumHelper
                                                                              
  def event_album_cover(event, size="medium")                                       
    if event.album.photos.count == 0
      link_to image_tag("default_cover_#{size}.jpg"), event_album_url(:event_id => event)
    elsif event.album.cover.blank?                                                  
      link_to image_tag(event.album.photos.first.public_filename(size)), event_album_url(:event_id => event)
    else
      link_to image_tag(event.album.cover.public_filename(size)), event_album_url(:event_id => event)
    end
  end 

end
