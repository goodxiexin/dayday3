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

  # get [next blog, prev blog, current blog index]
  def self.next_prev_video(user, video)
    size = user.videos.count
    next_video_idx = 0
    prev_video_idx = 0
    cur_video_idx = 0
    user.videos.each_with_index do |b, i|
      if video == b
        cur_video_idx = i
        next_video_idx = (i + 1) % size
        prev_video_idx = (i - 1 + size) % size
      end
    end
    [user.videos[next_video_idx], user.videos[prev_video_idx], cur_video_idx]
  end 
 
end
