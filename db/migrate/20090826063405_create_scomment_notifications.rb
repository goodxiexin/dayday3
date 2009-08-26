class CreateScommentNotifications < ActiveRecord::Migration
  def self.up
    create_table :scomment_notifications do |t|
      t.integer :user_id
      t.integer :commentor_id
      t.integer :comment_id
      t.boolean :read, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :scomment_notifications
  end
end
