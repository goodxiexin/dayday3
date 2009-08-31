class TagNotification < ActiveRecord::Base

  belongs_to :tag,
             :polymorphic => true

  belongs_to :user

  def self.find_read_notifications(*args)
    with_creation_order {
      find(*args)
    }
  end
  
  def self.with_creation_order
    with_scope(:find => {:order => "created_at DESC"}) do
      yield
    end
  end

end
