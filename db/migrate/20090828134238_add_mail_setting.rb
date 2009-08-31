class AddMailSetting < ActiveRecord::Migration
  def self.up
        gaoxh = User.find_by_login('gaoxh')
    micai = User.find_by_login('micai')
    MailSetting.create(:user_id => gaoxh.id)
    MailSetting.create(:user_id => micai.id)
    50.times do |i|
      user = User.find_by_login("user#{i}")
      MailSetting.create(:user_id => user.id)
    end

  end

  def self.down
  end
end
