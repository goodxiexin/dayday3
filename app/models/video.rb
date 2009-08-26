class Video < ActiveRecord::Base

  # the owner of this video
  belongs_to :user

  # the category of this game
  belongs_to :game

  # your friend can comment your video
  has_many :comments,
           :class_name => 'Vcomment',
           :dependent => :destroy

  # you can tag your friends in your video
  has_many :tags,
           :class_name => 'Vtag',
           :dependent => :destroy

  has_many :digs,
           :class_name => 'Vdig',
           :dependent => :destroy

  acts_as_diggable

  acts_as_taggable

  acts_as_commentable

  # improve performance of next, prev performance
  acts_as_list :scope => :user

  acts_as_resource_feeder

  class VideoURLNotValid < StandardError; end

  def self.generate_link(url)
    if (url =~ /youku\.com/)
      startPos = (url =~ /\/id_/)
      videoId = url[(startPos + 4)..-6]
      videoUrl = "http://player.youku.com/player.php/sid/"+ videoId +"/v.swf"
      return "<embed src=\""+ videoUrl + "\" quality=\"high\" width=\"480\" height=\"400\" align=\"middle\" allowScriptAccess=\"sameDomain\" type=\"application/x-shockwave-flash\"></embed>"
    elsif (url =~ /tudou\.com/)
      startPos = (url =~ /view\//)
      videoId = url[(startPos + 5)..-2]
      videoUrl = "http://www.tudou.com/v/"+videoId
      return "<object width=\"420\" height=\"363\"><param name=\"movie\" value=\""+ videoUrl +"\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><param name=\"wmode\" value=\"opaque\"></param><embed src=\""+ videoUrl+"\"type=\"application/x-shockwave-flash\" allowscriptaccess=\"always\" allowfullscreen=\"true\" wmode=\"opaque\" width=\"420\" height=\"363\"></embed></object>"
    else
      raise VideoURLNotValid    
    end
  end

  def self.find_public_viewable(*args)
    with_public_viewable { find(*args) }
  end

  def self.find_friend_viewable(*args)
    with_friend_viewable { find(*args) }
  end

  def self.with_position_order
    with_scope(:find => {:order => 'position DESC'}) do
      yield
    end
  end

  def self.with_public_viewable
    with_position_order do
      with_scope(:find => {:conditions => ["privilege = 'all'"]}) do
        yield
      end
    end
  end

  def self.with_friend_viewable
    with_position_order do
      with_scope(:find => {:conditions => ["(privilege = 'all' OR privilege = 'friends')"]}) do
        yield
      end
    end
  end

end
