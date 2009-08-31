class AddPersonalSetting < ActiveRecord::Migration
  def self.up
    gaoxh = User.find_by_login('gaoxh')
    micai = User.find_by_login('micai')
    PrivacySetting.create(:user_id => gaoxh.id)
    PrivacySetting.create(:user_id => micai.id)
    50.times do |i|
      user = User.find_by_login("user#{i}")
      PrivacySetting.create(:user_id => user.id)
    end 
  end

  def self.down
  end
end
