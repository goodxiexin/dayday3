class Photo < ActiveRecord::Base

  belongs_to :user

  # we use counter_cache technique here
  belongs_to :album,
             :counter_cache => true

  # your friends can comment on single photo
  has_many :comments,
           :class_name => 'Pcomment',
           :dependent => :destroy

  # people can dig your photo
  has_many :digs,
           :class_name => 'Pdig',
           :dependent => :destroy

  # user can tag his friends in the photo
  has_many :tags,
           :class_name => 'Ptag',
           :dependent => :destroy

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

  acts_as_diggable

  acts_as_taggable

  acts_as_commentable

  # improves performance of next, prev functionality
  acts_as_list :scope => :album
end
