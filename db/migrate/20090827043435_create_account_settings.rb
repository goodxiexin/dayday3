class CreateAccountSettings < ActiveRecord::Migration
  def self.up
    create_table :account_settings do |t|
      
      t.timestamps
    end
  end

  def self.down
    drop_table :account_settings
  end
end
