class CreateCommentNotifications < ActiveRecord::Migration
  def self.up
    create_table :comment_notifications do |t|
      t.integer :user_id
      t.integer :comment_id
      t.string :comment_type
      t.boolean :read, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :comment_notifications
  end
end
