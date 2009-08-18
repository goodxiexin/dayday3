require 'active_record'

module Taggable
  def acts_as_taggable    
    # get resource type and its tag type
    type = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s   
    tag_type = type[0,1].to_s + "tag"
    type_p = type.downcase.pluralize
    tag_type_p = tag_type.downcase.pluralize

    # tag someone
    define_method("tag") do |user_id, tagged_user_id, *args|
      parameters  = {:user_id => user_id, :tagged_user_id => tagged_user_id}.merge(args.first || {})
      self.tags.find_or_create_by_tagged_user_id(parameters)
    end

    # get resources where you are tagged in the order of time
    self.metaclass.send(:define_method, 'tagged') do |user_id, page, per_page|
      sql = "select DISTINCT #{type_p}.* FROM #{type_p} INNER JOIN #{tag_type_p} " +
            "where #{tag_type_p}.tagged_user_id = #{user_id} and #{tag_type_p}.#{type}_id = #{type_p}.id " +
            "ORDER BY updated_at DESC"
      eval("#{type}").paginate_by_sql sql, :page => page, :per_page => per_page
    end
  end
end

ActiveRecord::Base.extend(Taggable)
