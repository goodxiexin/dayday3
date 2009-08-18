class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos, :force => true do |t|
      t.integer :digs_count, :default => 0
      t.integer :tags_count, :default => 0
      t.integer :comments_count, :default => 0
      t.integer :album_id
      t.boolean :cover, :default => false
      t.text :notation

      # attachment_fu fields
      t.integer :parent_id
      t.string :content_type
      t.string :filename
      t.string :thumbnail
      t.integer :size
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
