class CommentNotification < ActiveRecord::Base

  belongs_to :user

  belongs_to :comment,
             :polymorphic => true

end
