class CreateVcommentNotifications < ActiveRecord::Migration
  def self.up
    create_table :vcomment_notifications do |t|
      t.integer :user_id
      t.integer :commentor_id
      t.integer :comment_id
      t.boolean :read, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :vcomment_notifications
  end
end
