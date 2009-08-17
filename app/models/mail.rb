class Mail < ActiveRecord::Base

  attr_accessor :recipients

  belongs_to :sender,
             :class_name => 'User'

  belongs_to :receiver,
             :class_name => 'User'
 
  belongs_to :parent,
             :class_name => 'Mail'

  has_many :children,
           :class_name => 'Mail',
           :foreign_key => 'parent_id',
           :order => 'created_at ASC'


  def self.paged_recv_mails(user_id, page, per_page)
    if per_page.blank?
      per_page = 10
    end
    Mail.paginate :conditions => {:receiver_id => user_id, :delete_by_receiver => false},
                  :page => page,
                  :per_page => per_page,
                  :order => "created_at DESC"
  end

  def self.paged_sent_mails(user_id, page, per_page)
    if per_page.blank?
      per_page = 10
    end
    Mail.paginate :conditions => {:sender_id => user_id, :delete_by_sender => false},
                  :page => page,
                  :per_page => per_page,
                  :order => "created_at DESC"
  end

  def mark_as_read(user_id)
    update_attribute(:read_by_receiver, true) if receiver?(user_id)
  end

  def mark_as_unread(user_id)
    update_attribute(:read_by_receiver, false) if receiver?(user_id)
  end

  # delete an email
  def mark_delete(user_id)
    if receiver?(user_id)
      update_attribute(:delete_by_receiver, true)
    elsif sender?(user_id)
      update_attribute(:delete_by_sender, true)
    end
  end

  private

  # if user is the receiver of this email
  def receiver?(user_id)
    (receiver_id == user_id)? true : false
  end

  # if user is the sender of this email
  def sender?(user_id)
    (sender_id == user_id)? true : false
  end

  # if this email is deleted by both sender and receiver
  def delete_by_both?
    (delete_by_receiver and delete_by_sender)? true : false
  end

end
