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

  # improves performance of next, prev functionality
  acts_as_list :scope => 'user_id = #{user_id} AND draft = 0'

  # thus we can call more_feeds(user_id, how_many) method to get blog feeds
  acts_as_resource_feeder :scope => 'draft = 0'

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
      with_scope(:find => {:conditions => ["draft = 0 AND privilege = 'all'"]}) do
        yield
      end
    end
  end

  def self.with_friend_viewable
    with_position_order do 
      with_scope(:find => {:conditions => ["draft = 0 AND (privilege = 'all' OR privilege = 'friends')"]}) do
        yield
      end
    end
  end

end
