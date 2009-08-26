class CreateVisitorRecords < ActiveRecord::Migration
  def self.up
    create_table :visitor_records, :force => true do |t|
      t.integer :user_id
      t.integer :visitor_id
      t.boolean :register, :default => true
      
      t.timestamps
    end
  end

  def self.down
    drop_table :visitor_records
  end
end
