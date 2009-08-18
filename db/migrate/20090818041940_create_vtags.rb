class CreateVtags < ActiveRecord::Migration
  def self.up
    create_table :vtags, :force => true do |t|
      t.integer :user_id
      t.integer :tagged_user_id
      t.integer :video_id

      t.timestamps
    end
  end

  def self.down
    drop_table :vtags
  end
end
