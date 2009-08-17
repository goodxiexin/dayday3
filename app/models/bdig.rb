class Bdig < ActiveRecord::Base

  belongs_to :user

  belongs_to :blog,
             :counter_cache => :digs_count 

end
