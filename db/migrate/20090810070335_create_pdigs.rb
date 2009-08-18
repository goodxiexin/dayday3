class CreatePdigs < ActiveRecord::Migration
  def self.up
    create_table :pdigs, :force => true do |t|
      t.integer :user_id
      t.integer :photo_id
      t.timestamps
    end
  end

  def self.down
    drop_table :pdigs
  end
end
