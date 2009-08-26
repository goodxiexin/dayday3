class AddAlbums < ActiveRecord::Migration
  def self.up
    gaoxh = User.find_by_login("gaoxh")
    wow = Game.find_by_name("world of warcraft")
    2.times do |i|
      gaoxh.albums.create(:game_id => wow.id, :title => "album #{i}") 
    end
    20.times do |i|
      user = User.find_by_login("user#{i}")
      user.albums.create(:game_id => wow.id, :title => "album #{i}")
    end
  end

  def self.down
  end
end
