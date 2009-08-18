class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games, :force => true do |t|
      t.string :name
      t.string :company
      t.datetime :sale_date
      t.text :description
      t.boolean :no_areas, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
