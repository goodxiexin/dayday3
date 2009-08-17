class Blog < ActiveRecord::Base

  # the owner of this blog
  belongs_to :user

  # the category of this game
  belongs_to :game

  # your friend can comment your blog
  has_many :comments,
           :class_name => 'Bcomment',
           :dependent => :destroy

  # you can tag your friends in your blog
  has_many :tags,
           :class_name => 'Btag',
           :dependent => :destroy

  has_many :digs,
           :class_name => 'Bdig',
           :dependent => :destroy

  acts_as_diggable

  acts_as_taggable

  acts_as_commentable

  # get [next blog, prev blog, current blog index]
  def self.next_prev_blog(user, blog)
    size = user.blogs.count
    next_blog_idx = 0
    prev_blog_idx = 0
    cur_blog_idx = 0
    user.blogs.each_with_index do |b, i|
      if blog == b
        cur_blog_idx = i
        next_blog_idx = (i + 1) % size
        prev_blog_idx = (i - 1 + size) % size
      end
    end
    [user.blogs[next_blog_idx], user.blogs[prev_blog_idx], cur_blog_idx]
  end

end
