class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs, :force => true do |t|
      t.integer :user_id
      t.integer :game_id
      t.string :title, :limit => 64
      t.text :content, :limit => 100000
      t.integer :digs_count, :default => 0
      t.integer :comments_count, :default => 0
      t.integer :tags_count, :default => 0
      t.boolean :draft, :default => true
      t.string :privilege

      t.timestamps
    end
  end

  def self.down
    drop_table :blogs
  end
end
