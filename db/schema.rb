# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090816174114) do

  create_table "albums", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "photos_count", :default => 0
    t.string   "title"
    t.text     "description"
    t.string   "privilege"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bcomments", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.integer  "blog_id",                       :null => false
    t.text     "content"
    t.boolean  "whisper",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bdigs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "blog_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blogs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.string   "title",          :limit => 64
    t.text     "content",        :limit => 16777215
    t.integer  "digs_count",                         :default => 0
    t.integer  "comments_count",                     :default => 0
    t.integer  "tags_count",                         :default => 0
    t.boolean  "draft",                              :default => true
    t.string   "privilege"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "btags", :force => true do |t|
    t.integer  "user_id"
    t.integer  "tagged_user_id"
    t.integer  "blog_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_areas", :force => true do |t|
    t.string   "name"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_characters", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "server_id"
    t.integer  "area_id"
    t.integer  "profession_id"
    t.integer  "race_id"
    t.string   "name"
    t.integer  "level"
    t.boolean  "playing"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_professions", :force => true do |t|
    t.string   "name"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_races", :force => true do |t|
    t.string   "name"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_servers", :force => true do |t|
    t.string   "name"
    t.string   "ip"
    t.integer  "game_id"
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.string   "name"
    t.string   "company"
    t.datetime "sale_date"
    t.text     "description"
    t.boolean  "no_areas",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "icons", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "current"
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mails", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.boolean  "delete_by_sender",   :default => false
    t.boolean  "delete_by_receiver", :default => false
    t.boolean  "read_by_sender",     :default => true
    t.boolean  "read_by_receiver",   :default => false
    t.string   "title"
    t.text     "content"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "permalink"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pcomments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "photo_id"
    t.text     "content"
    t.boolean  "whisper",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pdigs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.string   "user_id"
    t.string   "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.integer  "digs_count",     :default => 0
    t.integer  "tags_count",     :default => 0
    t.integer  "comments_count", :default => 0
    t.integer  "album_id"
    t.boolean  "cover",          :default => false
    t.text     "notation"
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "provinces", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ptags", :force => true do |t|
    t.integer  "user_id"
    t.integer  "tagged_user_id"
    t.integer  "photo_id"
    t.integer  "x"
    t.integer  "y"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", :force => true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 64
    t.string   "email",                     :limit => 128
    t.string   "crypted_password",          :limit => 64
    t.string   "salt",                      :limit => 40
    t.string   "gender"
    t.boolean  "enabled",                                  :default => true
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "password_reset_code",       :limit => 40
    t.integer  "country_id"
    t.integer  "province_id"
    t.integer  "city_id"
    t.integer  "qq"
    t.integer  "mobile"
    t.string   "website"
    t.datetime "birthday"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wall_messages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "poster_id"
    t.integer  "receiver_id"
    t.text     "content"
    t.boolean  "whisper",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
