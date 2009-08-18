class CreateBdigs < ActiveRecord::Migration
  def self.up
    create_table :bdigs, :force => true do |t|
      t.integer :user_id
      t.integer :blog_id

      t.timestamps
    end
  end

  def self.down
    drop_table :bdigs
  end
end
