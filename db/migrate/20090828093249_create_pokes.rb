class CreatePokes < ActiveRecord::Migration
  def self.up
    create_table :pokes do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.string :content, :default => 'hi'    
      t.timestamps
    end
  end

  def self.down
    drop_table :pokes
  end
end
