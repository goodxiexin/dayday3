class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums, :force => true do |t|
      t.integer :user_id
      t.integer :game_id
      t.integer :photos_count, :default => 0
      t.string :title
      t.text :description
      t.string :privilege
      t.timestamps
    end
  end

  def self.down
    drop_table :albums
  end
end
