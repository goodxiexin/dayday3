class AddMails < ActiveRecord::Migration
  def self.up
    gaoxh = User.find_by_login("gaoxh")
    micai = User.find_by_login("micai")
    mail = Mail.create(
      :sender_id => micai.id,
      :receiver_id => gaoxh.id,
      :title => 'hello',
      :content => 'this is mingfei, how are you?')
    mail.parent_id = mail.id
    mail.save
    title = "reply to: hello"
    Mail.create(
      :sender_id => gaoxh.id,
      :receiver_id => micai.id,
      :parent_id => mail.id,
      :title => title,
      :content => 'very good... how\'s it going?')
    Mail.create(
      :sender_id => gaoxh.id,
      :receiver_id => micai.id,
      :parent_id => mail.id,
      :title => title,
      :content => 'by the way... do you have a girl friend')
    Mail.create(
      :sender_id => micai.id,
      :receiver_id => gaoxh.id,
      :content => 'not yet.. how about you?',
      :title => title,
      :parent_id => mail.id)
    30.times do |i|
      mail = Mail.create(
        :sender_id => gaoxh.id,
        :receiver_id => User.find_by_login("user#{i}").id,
        :title => "hello user#{i}",
        :content => "this is xiahong, how are you user#{i}")
      mail.parent_id = mail.id
      mail.save
    end
    30.times do |i|
      mail = Mail.create(
        :sender_id => User.find_by_login("user#{i}").id,
        :receiver_id => gaoxh.id,
        :title => 'hello',
        :content => "this is user#{i}, how are you?")
      mail.parent_id = mail.id
      mail.save
    end
  end

  def self.down
  end
end
