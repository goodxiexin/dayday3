class CreateBcommentNotifications < ActiveRecord::Migration
  def self.up
    create_table :bcomment_notifications, :force => true do |t|
      t.integer :user_id
      t.integer :commentor_id
      t.integer :blog_id
      t.timestamps
    end
  end

  def self.down
    drop_table :bcomment_notifications
  end
end
