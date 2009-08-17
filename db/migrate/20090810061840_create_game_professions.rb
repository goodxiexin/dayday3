class CreateGameProfessions < ActiveRecord::Migration
  def self.up
    create_table :game_professions, :force => true do |t|
      t.string :name
      t.integer :game_id
      t.timestamps
    end
  end

  def self.down
    drop_table :game_professions
  end
end
