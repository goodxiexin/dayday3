class AddWallMessages < ActiveRecord::Migration
  def self.up
    gaoxh = User.find_by_login("gaoxh")
    micai = User.find_by_login("micai")
    gaoxh.wall_messages.create(
      :poster_id => micai.id,
      :receiver_id => gaoxh.id,
      :content => "hello, i am micai")
    40.times do |i|
      gaoxh.wall_messages.create(
	:poster_id => User.find_by_login("user#{i}").id,
        :receiver_id => gaoxh.id,
      	:content => "hello, i am user #{i}")
    end
  end

  def self.down
  end
end
