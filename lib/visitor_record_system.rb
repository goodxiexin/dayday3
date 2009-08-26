module VisitorRecordSystem

  def record_visiting
    VisitorRecord.update_or_create(resource_owner, current_user)
  end

end
