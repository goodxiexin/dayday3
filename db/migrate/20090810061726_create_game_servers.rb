class CreateGameServers < ActiveRecord::Migration
  def self.up
    create_table :game_servers, :force => true do |t|
      t.string :name
      t.string :ip
      t.integer :game_id
      t.integer :area_id

      t.timestamps
    end
  end

  def self.down
    drop_table :game_servers
  end
end
