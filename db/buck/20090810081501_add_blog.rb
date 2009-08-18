class AddBlog < ActiveRecord::Migration
  def self.up
    wow = Game.find_by_name("world of warcraft")
    gaoxh = User.find_by_login('gaoxh')
    20.times do |i|
      gaoxh.blogs.create(
	:title => "blog #{i}",
	:game_id => wow.id,
        :draft => false,
	:content => "hello, everyone. this is blog #{i}. hope you will enjoy it")
    end
  end

  def self.down
  end
end
