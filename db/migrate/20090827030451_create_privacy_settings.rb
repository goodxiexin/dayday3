class CreatePrivacySettings < ActiveRecord::Migration
  def self.up
    create_table :privacy_settings do |t|
      t.integer :user_id
      t.integer :personal, :default => 1 # 0 - all 1 - friends 2 - same game
      t.integer :friend, :default => 0 # 0 - all 1 - same game
      t.boolean :search, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :privacy_settings
  end
end
