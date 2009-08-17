class Country < ActiveRecord::Base

  has_many :provinces

  has_many :users

end
