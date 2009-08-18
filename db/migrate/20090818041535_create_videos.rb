class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos, :force => true do |t|
      t.integer :user_id
      t.integer :game_id
      t.string :title
      t.string :url
      t.text :link
      t.integer :digs_count, :default => 0
      t.integer :comments_count, :default => 0
      t.integer :tags_count, :default => 0
      t.string :privilege
      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
