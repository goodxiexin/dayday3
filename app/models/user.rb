require 'digest/sha1'

class User < ActiveRecord::Base

  has_many :friend_requests,
           :foreign_key => 'receiver_id',
           :order => 'created_at DESC',
           :dependent => :destroy

  # users that has sent requests to this user
  has_many :requested_friends,
           :class_name => 'User',
           :through => :friend_requests,
           :source => :sender

  has_many :friend_wanted,
           :class_name => 'friend_requests',
           :foreign_key => 'sender_id',
           :dependent => :destroy

  # users that this user want to be a friend with
  has_many :wanted_friends,
           :class_name => 'User',
           :through => :friend_requests,
           :source => :receiver

  def has_friend_request(user)
    self.requested_friends.include?(user) or user.wanted_friends.include?(self)
  end  

  has_many :friend_notifications

  has_one :privacy_setting

  has_one :mail_setting

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

  has_many :friend_guesses,
           :dependent => :destroy

  def has_enough_friend_guesses
    self.friend_guesses.count > 40
  end

  has_many :guessed_friends,
           :class_name => 'User',
           :foreign_key => 'guess_id',
           :through => :friend_guesses,
           :uniq => true


  def destroy_existing_guesses
    unless self.friend_guesses.empty?
      self.friend_guesses.each do |guess|
        guess.destroy
      end
    end
  end

  def collect_friend_guesses(guessed_users)
    # go through all events find people that attending the same event as the current user
    # those users are most like to be friend with current user
    # event is not selected randomly because each new event is very likely bring people together
    self.events.each do |event|
      catch(:done) do
        event.must_attenders.each do |user|
          unless (self.id == user.id or self.has_friend(user) or self.has_friend_request(user))
            guessed_users[user.id] += 1
            throw :done if (guessed_users.size >= 200)
          end
        end
      end
    end

    # if events collect enough users then friends' friends are not collected.
    # otherwise, friends' friends are collected for consideration
    # friends' friends are selected randomly to avoid same users are used every time
    unless (guessed_users.size >= 200)
      catch(:done1) do 
        self.friends.each do |friend|
          @n = friend.friends.size
          @n.times do |i|
            @user_guess = friend.friends[rand(@n)]
            unless (self.id == @user_guess.id or self.has_friend(@user_guess) or self.has_friend_request(@user_guess) )
              guessed_users[@user_guess.id] += 2
              throw :done1 if (guessed_users.size >= 200)
            end
          end
        end
      end
    end

    # if previous step has not get enough users, all users in same servers are considered
    unless (guessed_users.size >= 200)
      catch(:done2) do
        self.game_characters.each do |each_character|
          @current_characters = each_character.server.game_characters.sort_by{rand}
          @current_characters.each do |other_character|
            unless (self.id == other_character.user.id or self.has_friend(other_character.user) or self.has_friend_request(other_character.user) )
              gussed_users[other_character.user.id] += 1
              throw :done2 if (guessed_users.size >= 200)
            end
          end
        end
      end 
    end

    # At this stage, every user is needed for this engine
    # this only occur when user does not provide enough info or we have not get enough users
    unless (guessed_users.size >= 200)
      catch(:done3) do
        User.all.each do |each_user|
          guessed_users[each_user.id] += 1
          throw :done3 if (guessed_users.size >= 200)
        end
      end
    end
  end

  def calculating_final_scores(guessed_users, suggested_users)
    guessed_users.each_key do |user_id|
      this_user = User.find(user_id)
      this_user.friends do |each_friend|
        if (self.has_friend(each_friend))
            suggested_users[user_id] += 2
        end
      end
      this_user.events do |each_event|
        if (self.has_attended_event(each_event))
            suggested_users[user_id] += 5
        end
      end
      this_user.game_characters do |each_game_character|
        self.game_characters do |this_game_character|
          if (this_game_character.server.id == each_game_character.server.id)
            suggested_users[user_id] +=2
          end
        end
      end
    end
  end

  # this method has three main part
  # first part is to destroy all existing samples
  # second part is to collect 200 samples
  # third part is to calculate sample quality
  def create_friend_guesses
    self.destroy_existing_guesses

    @guessed_users = {}
    @guessed_users.default = 0
    self.collect_friend_guesses(@guessed_users)

    @suggested_users = @guessed_users
    @suggested_users.each_key do |user_id|
      @suggested_users[user_id] = 1
    end
    self.calculating_final_scores(@guessed_users, @suggested_users)

    @min_num = [50, @suggested_users.size].min
    @final_suggestions = @suggested_users.sort{|a,b| a[1] <=> b[1]}[0..@min_num]
    
    @final_suggestions.each do |element|
      self.friend_guesses.create(:guess_id => element[0])
    end
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

  has_many :participations,
           :foreign_key => 'participant_id',
           :dependent => :destroy

  has_many :events,
           :through => :participations,
           :uniq => true

  def has_attended_event(event)
    self.events.include?(event)
  end

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

  has_many :drafts,
           :class_name => 'Blog',
           :order => 'updated_at DESC',
           :conditions => {:draft => true}

  has_many :albums,
           :order => 'updated_at DESC'

  has_many :videos,
           :order => 'position DESC'

  has_many :tag_notifications,
           :order => 'created_at DESC'

  has_many :comment_notifications,
           :order => 'created_at DESC'

  has_many :pokes,
           :foreign_key => 'receiver_id',
           :order => 'created_at DESC'

  # permissions and roles
  has_many :permissions
  has_many :roles, :through => :permissions

  # Virtual attribute for the unencrypted password
  attr_accessor :password, :password_confirmation

  # callbacks
  before_save :encrypt_password
  before_create :make_activation_code

  # friend guesses are built after a user is created
  after_create :create_friend_guesses

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
