class VisitorRecord < ActiveRecord::Base

  belongs_to :user

  belongs_to :visitor,
             :class_name => 'User'

  def self.update_or_create(user, visitor)
    unless user == visitor
      visitor_record = user.visitor_records.find(:first, :conditions => {:user_id => user.id, :visitor_id => visitor.id})
      if visitor_record
        visitor_record.update_attribute('created_at', Time.now.to_s(:db))
      else
        user.visitor_records.create(:user_id => user.id, :visitor_id => visitor.id)
      end
    end
  end

end
