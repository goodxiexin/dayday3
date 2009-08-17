require 'active_record'

module Diggable
  def acts_as_diggable
    # someone dig this resource
    define_method("dig") do |user_id|
      self.digs.find_or_create_by_user_id(user_id)
    end
  end
end

ActiveRecord::Base.extend(Diggable)
