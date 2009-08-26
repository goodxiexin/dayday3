class CreateEventWallMessages < ActiveRecord::Migration
  def self.up
    create_table :event_wall_messages do |t|
      t.integer :event_id
      t.integer :poster_id
      t.integer :receiver_id
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :event_wall_messages
  end
end
