class CreatePcomments < ActiveRecord::Migration
  def self.up
    create_table :pcomments, :force => true do |t|
      t.integer :user_id
      t.integer :photo_id
      t.integer :receiver_id
      t.text :content
      t.boolean :whisper, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :pcomments
  end
end
