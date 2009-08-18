class CreatePtags < ActiveRecord::Migration
  def self.up
    create_table :ptags, :force => true do |t|
      t.integer :user_id
      t.integer :tagged_user_id
      t.integer :photo_id
      t.integer :x, :y, :width, :height

      t.timestamps
    end
  end

  def self.down
    drop_table :ptags
  end
end
