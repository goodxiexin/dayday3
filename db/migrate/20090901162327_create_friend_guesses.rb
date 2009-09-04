class CreateFriendGuesses < ActiveRecord::Migration
  def self.up
    create_table :friend_guesses do |t|
      t.integer :user_id
      t.integer :guess_id
      t.timestamps
    end
  end

  def self.down
    drop_table :friend_guesses
  end
end
