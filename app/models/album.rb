class Album < ActiveRecord::Base

  # a user can post multiple albums
  belongs_to :user

  # the category of this album
  belongs_to :game

  # each album has one cover
  has_one :cover,
          :class_name => 'Photo',
          :conditions => {:cover => true},
          :dependent => :destroy

  # each album has many photos
  has_many :photos,
           :dependent => :destroy

  # return [next photo, prev photo, current photo index]
  def next_prev_photo(cur_photo)
    size = self.photos.count
    next_photo_idx = 0
    prev_photo_idx = 0
    cur_photo_idx = 0
    self.photos.each_with_index do |photo, i|
      if cur_photo == photo
        next_photo_idx = (i + 1) % size
        prev_photo_idx = (i - 1 + size) % size
        cur_photo_idx = i + 1
        break
      end
    end
    [self.photos[next_photo_idx], self.photos[prev_photo_idx], cur_photo_idx] 
  end

  # reset the cover of the album
  def reset_cover(new_cover_id)
    new_cover = Photo.find(new_cover_id)
    old_cover = self.cover
    unless new_cover == old_cover
      old_cover.update_attribute(:cover, false) unless old_cover.blank?
      new_cover.cover = true
      new_cover.album_id = self.id
      new_cover.save
    end
  end


end
