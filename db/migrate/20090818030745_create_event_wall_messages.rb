class CreateEventWallMessages < ActiveRecord::Migration
  def self.up
    create_table :event_wall_messages do |t|
      t.integer :activity_id
      t.integer :poster_id
      t.integer :receiver_id
      t.text :content
      t.boolean :whisper, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :event_wall_messages
  end
end
