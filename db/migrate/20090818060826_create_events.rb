class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :title
      t.integer :poster_id
      t.integer :game_id
      t.integer :game_server_id
      t.integer :game_area_id
      t.integer :album_id
      t.integer :participations_count, :default => 0
      t.datetime :time
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
