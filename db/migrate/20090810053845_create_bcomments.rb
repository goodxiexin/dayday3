class CreateBcomments < ActiveRecord::Migration
  def self.up
    create_table :bcomments do |t|
      t.integer :user_id
      t.integer :blog_id
      t.integer :receiver_id
      t.text :content, :maximum => 1024
      t.boolean :whisper, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :bcomments
  end
end
