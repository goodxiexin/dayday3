class CreateScomments < ActiveRecord::Migration
  def self.up
    create_table :scomments, :force => true do |t|
      t.integer :user_id
      t.integer :status_id
      t.integer :receiver_id
      t.text :content
      t.boolean :whisper, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :scomments
  end
end
