class CreateWallMessages < ActiveRecord::Migration
  def self.up
    create_table :wall_messages, :force => true do |t|
      t.integer :user_id
      t.integer :poster_id
      t.integer :receiver_id
      t.text :content
      t.boolean :whisper, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :wall_messages
  end
end
