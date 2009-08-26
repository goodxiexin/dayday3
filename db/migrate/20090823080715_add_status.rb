class AddStatus < ActiveRecord::Migration
  def self.up
    gaoxh = User.find_by_login('gaoxh')
    micai = User.find_by_login('micai')
    gaoxh.statuses.create(:content => 'this is gaoxh')
    micai.statuses.create(:content => 'this is micai')
    5.times do |i|
      user = User.find_by_login("user#{i}")
     user.statuses.create(:content => "this is user#{i}", :created_at => '2009-8-22')
    end
    5.times do |i|
      user = User.find_by_login("user#{5+i}")
     user.statuses.create(:content => "this is user#{i}", :created_at => '2009-8-21')
    end
    5.times do |i|
      user = User.find_by_login("user#{10+i}")
     user.statuses.create(:content => "this is user#{i}", :created_at => '2009-8-20')
    end
    5.times do |i|
      user = User.find_by_login("user#{15+i}")
     user.statuses.create(:content => "this is user#{i}", :created_at => '2009-8-19')
    end
    5.times do |i|
      user = User.find_by_login("user#{20+i}")
     user.statuses.create(:content => "this is user#{i}", :created_at => '2009-8-18')
    end
    5.times do |i|
      user = User.find_by_login("user#{25+i}")
     user.statuses.create(:content => "this is user#{i}", :created_at => '2009-8-17')
    end

  end

  def self.down
  end
end
