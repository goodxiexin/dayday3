class CreateBcomments < ActiveRecord::Migration
  def self.up
    create_table :bcomments do |t|
      t.integer :user_id, :null => false
      t.integer :blog_id, :null => false
      t.text :content, :maximum => 1024
      t.boolean :whisper, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :bcomments
  end
end
