class Pdig < ActiveRecord::Base

  belongs_to :user

  belongs_to :photo,
             :counter_cache => 'digs_count'

end
