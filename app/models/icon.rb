class Icon < ActiveRecord::Base

  belongs_to :user

  # the icon is resized and stored in file system
  # also each cover has 3 thumbnails stored in file system
  has_attachment :content_type => :image,
                 :storage => :file_system,
                 :max_size => 8.megabytes,
                 :thumbnails => { :large => '320x320>',
                                  :medium => '160x160>',
                                  :small => '80x80>' }

  # prevent image sizes out of range
  validates_as_attachment

end
