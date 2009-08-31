class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.string :login, :limit => 64
      t.string :email, :limit => 128
      t.string :crypted_password, :limit => 64
      t.string :salt, :limit => 40
      t.string :gender
      t.boolean :enabled, :default => true
      t.string :remember_token
      t.datetime :remember_token_expires_at
      t.string :activation_code, :limit => 40
      t.datetime :activated_at
      t.string :password_reset_code, :limit => 40

      # profile
      t.integer :country_id, :province_id, :city_id
      t.integer :qq, :mobile
      t.string :website
      t.datetime :birthday

      t.timestamps
    end
  end

  def self.down
    drop_table "users"
  end
end
