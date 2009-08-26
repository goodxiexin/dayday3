class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses, :force => true do |t|
      t.integer :user_id
      t.text :content
      t.integer :comments_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :statuses
  end
end
