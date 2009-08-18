class CreateGameCharacters < ActiveRecord::Migration
  def self.up
    create_table :game_characters, :force => true do |t|
      t.integer :user_id
      t.integer :game_id
      t.integer :server_id
      t.integer :area_id
      t.integer :profession_id
      t.integer :race_id
      t.string :name
      t.integer :level
      t.boolean :playing

      t.timestamps
    end
  end

  def self.down
    drop_table :game_characters
  end
end
