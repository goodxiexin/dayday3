class AddUser < ActiveRecord::Migration
  def self.up
    user = User.new
    user.login = 'gaoxh'
    user.password = '111111'
    user.password_confirmation = '111111'
    user.email = 'gaoxh04@gmail.com'
    user.gender = 'male'
    user.save(false)
    user.activate
    user = User.new
    user.login = 'xiexin'
    user.password = '111111'
    user.password_confirmation = '111111'
    user.email = 'xiexinwang@gmail.com'
    user.gender = 'male'
    user.save(false)
    user.activate
    user = User.new
    user.login = 'micai'
    user.password = '111111'
    user.password_confirmation = '111111'
    user.email = 'gaoxiahong1020@yahoo.com.cn'
    user.gender = 'male'
    user.save(false)
    user.activate
    50.times do |i|
      user = User.new
      user.login = "user#{i}"
      user.password = '111111'
      user.password_confirmation = '111111'
      user.email = "user#{i}@gmail.com"
      user.gender = 'male'
      user.save(false)
      user.activate
    end
  end

  def self.down
  end
end
