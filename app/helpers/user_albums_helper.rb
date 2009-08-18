module UserAlbumsHelper

  def album_cover(album, size="medium")
    if album.photos.count == 0
      link_to image_tag("default_cover_#{size}.jpg"), user_album_url(:user_id => album.user, :id => album)
    elsif album.cover.blank?
      link_to image_tag(album.photos.first.public_filename(size)), user_album_url(:user_id => album.user, :id => album)
    else
      link_to image_tag(album.cover.public_filename(size)), user_album_url(:user_id => album.user, :id => album)
    end
  end

  def link_to_album(album)
    link_to album.title, user_album_url(:user_id => album.user, :id => album)
  end

  def link_to_edit_album(album)
    link_to 'edit album', edit_user_album_url(:user_id => @user, :id => album)
  end

end
