class CreateTagNotifications < ActiveRecord::Migration
  def self.up
    create_table :tag_notifications do |t|
      t.integer :user_id
      t.integer :tag_id
      t.string :tag_type
      t.boolean :read, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :tag_notifications
  end
end
