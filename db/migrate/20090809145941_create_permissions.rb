class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions, :force => true do |t|
      t.string :user_id
      t.string :role_id
      t.timestamps
    end
  end

  def self.down
    drop_table :permissions
  end
end
