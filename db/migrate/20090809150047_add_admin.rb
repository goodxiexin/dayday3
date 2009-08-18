class AddAdmin < ActiveRecord::Migration
  def self.up
    user = User.new
    user.login = 'admin'
    user.password = '20041065'
    user.password_confirmation = '20041065'
    user.email = 'gaoxh05@gmail.com'
    user.gender = 'male'
    user.save(false)
    user.activate
    role = Role.find_by_name('administrator')
    user = User.find_by_login('admin')
    permission = Permission.new
    permission.role = role
    permission.user = user
    permission.save(false)
  end

  def self.down
    
  end
end
