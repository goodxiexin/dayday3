class Status < ActiveRecord::Base

  belongs_to :user

  has_many :comments,
           :class_name => 'Scomment',
           :order => 'created_at DESC',
           :dependent => :destroy

  acts_as_resource_feeder

end
