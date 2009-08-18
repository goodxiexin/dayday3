require 'active_record'

module Commentable
  def acts_as_commentable
    
    define_method("comment") do |user_id, *args|
      parameters = {:user_id => user_id}.merge(args.first || {})   
      self.comments.create(parameters)
    end

  end
end

ActiveRecord::Base.extend(Commentable)
