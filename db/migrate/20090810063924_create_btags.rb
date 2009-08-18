class CreateBtags < ActiveRecord::Migration
  def self.up
    create_table :btags, :force => true do |t|
      t.integer :user_id
      t.integer :tagged_user_id
      t.integer :blog_id
      t.timestamps
    end
  end

  def self.down
    drop_table :btags
  end
end
