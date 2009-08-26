require 'digest/sha1'

class User < ActiveRecord::Base

  has_many :visitor_records,
           :order => 'created_at DESC'

  belongs_to :city

  belongs_to :province

  belongs_to :country

  has_many :wall_messages,
           :dependent => :destroy,
           :finder_sql => 'select wall_messages.* from wall_messages where wall_messages.user_id = #{id} OR wall_messages.receiver_id = #{id} ORDER BY created_at DESC'

  has_many :sent_mails,
           :class_name => 'Mail',
           :foreign_key => 'sender_id',
           :conditions => { :delete_by_sender => false }

  has_many :recv_mails,
           :class_name => 'Mail',
           :foreign_key => 'receiver_id',
           :conditions => { :delete_by_receiver => false }

  def unread_recv_mails_count
    recv_mails.find_all { |m| !m.read_by_receiver? }.count
  end

  has_many :friendships,
           :dependent => :destroy

  has_many :friends,
           :class_name => 'User',
           :order => 'login ASC',
           :through => :friendships

  def has_friend(user)
    self.friends.include?(user)
  end

  has_many :game_characters,
           :dependent => :destroy
  
  has_many :currently_playing_game_characters,
           :class_name => 'GameCharacter',
           :conditions => { :playing => true },
           :order => 'created_at DESC'

  has_many :games,
           :through => :game_characters,
           :uniq => true

  has_many :icons,
           :class_name => 'Photo',
           :order => 'created_at DESC',
           :dependent => :destroy

  has_one :current_icon,
          :class_name => 'Photo',
          :order => 'created_at DESC',
          :conditions => {:current_icon => true}

  def next_prev_icon(cur_icon)
    size = self.icons.count
    next_icon_idx = 0
    prev_icon_idx = 0
    cur_icon_idx = 0
    self.icons.each_with_index do |icon, i|
      if cur_icon == icon
        next_icon_idx = (i + 1) % size
        prev_icon_idx = (i - 1 + size) % size
        cur_icon_idx = i + 1
        break
      end
    end
    [self.icons[next_icon_idx], self.icons[prev_icon_idx], cur_icon_idx]
  end

  def reset_icon(new_icon)
    old_icon = self.current_icon
    unless new_icon == old_icon
      old_icon.update_attribute(:current_icon, false) unless old_icon.blank?
      new_icon.current_icon = true
      new_icon.user_id = self.id
    end
  end

  has_many :statuses,
           :order => 'created_at DESC',
           :dependent => :destroy

  has_one :latest_status,
          :class_name => 'Status',
          :order => 'created_at DESC'

  has_many :blogs,
           :order => 'position DESC',
           :conditions => {:draft => false}

  has_many :bcomment_notifications,
           :order => 'created_at DESC'
 
  def can_view(blog)
    return true if blog.user == self 
    case blog.privilege
    when 'all'
      return true
    when 'myself'
      return (blog.user == self)
    when 'only friends'
      return blog.user.has_friend(self)
    end
  end
 
  has_many :drafts,
           :class_name => 'Blog',
           :order => 'updated_at DESC',
           :conditions => {:draft => true}

  has_many :albums,
           :order => 'updated_at DESC'

  has_many :videos,
           :order => 'position DESC'

  # permissions and roles
  has_many :permissions
  has_many :roles, :through => :permissions

  # Virtual attribute for the unencrypted password
  attr_accessor :password, :password_confirmation

  # callbacks
  before_save :encrypt_password
  before_create :make_activation_code

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :gender, :password, :password_confirmation, :qq, :website, :mobile, :country, :city, :province, :birthday

  # Activates the user in the database.
  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(email, password)
    u = find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email]
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token = nil
    save(false)
  end

  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
  end

  def reset_password
    update_attribute(:password_reset_code, nil)
    @reset_password = true
  end

  def has_role?(name)
    self.roles.find_by_name(name) ? true : false
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def recently_forgot_password?
    @forgotten_password
  end

  def recently_reset_password?
    @reset_password
  end

protected
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end

  def make_activation_code
    self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

  def make_password_reset_code
    self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
 
end
