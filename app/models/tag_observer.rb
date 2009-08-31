class TagObserver < ActiveRecord::Observer

  observe :Btag, :Vtag, :Ptag

  def after_save(tag)
    TagNotification.create(:user_id => tag.tagged_user_id, :tag_id => tag.id, :tag_type => tag.class.to_s)
  end

end

