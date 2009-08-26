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
           :order => 'position DESC',
           :dependent => :destroy

  acts_as_resource_feeder

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

  def self.find_public_viewable(*args)
    with_public_viewable { find(*args) }
  end

  def self.find_friend_viewable(*args)
    with_friend_viewable { find(*args) }
  end

  def self.with_creation_order
    with_scope(:find => {:order => "created_at DESC"}) do
      yield
    end
  end

  def self.with_public_viewable
    with_creation_order do
      with_scope(:find => {:conditions => ["privilege = 'all'"]}) do
        yield
      end
    end
  end

  def self.with_friend_viewable
    with_creation_order do
      with_scope(:find => {:conditions => ["(privilege = 'all' OR privilege = 'friends')"]}) do
        yield
      end
    end
  end

end
