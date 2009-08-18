class CreateVdigs < ActiveRecord::Migration
  def self.up
    create_table :vdigs, :force => true do |t|
      t.integer :user_id
      t.integer :video_id

      t.timestamps
    end
  end

  def self.down
    drop_table :vdigs
  end
end
