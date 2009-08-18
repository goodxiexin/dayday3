class AddDrafts < ActiveRecord::Migration
  def self.up
    gaoxh = User.find_by_login('gaoxh')
    wow = Game.find_by_name("world of warcraft")
    20.times do |i|
      gaoxh.drafts.create(
        :title => "draft #{i}",
        :game_id => wow.id,
        :content => "hello, this is draft #{i}. i will finish it soon")
    end
  end

  def self.down
  end
end
