class CreateVcomments < ActiveRecord::Migration
  def self.up
    create_table :vcomments, :force => true do |t|
      t.integer :user_id
      t.integer :video_id
      t.integer :receiver_id
      t.text :content
      t.boolean :whisper, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :vcomments
  end
end
