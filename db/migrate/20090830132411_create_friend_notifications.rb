class CreateFriendNotifications < ActiveRecord::Migration
  def self.up
    create_table :friend_notifications do |t|
      t.integer :user_id
      t.integer :sender_id
      t.string :content # decline, accept or request
      t.timestamps
    end
  end

  def self.down
    drop_table :friend_notifications
  end
end
