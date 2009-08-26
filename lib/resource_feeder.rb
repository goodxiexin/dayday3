require 'active_record'

module ResourceFeeder
  
  Intervals = [{:from => 1, :to => 0},
               {:from => 3, :to => 1},
               {:from => 7, :to => 3},
               {:from => 0, :to => 7}]

  def acts_as_resource_feeder(options={})
    type = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s
    type_p = type.downcase.pluralize
    scope = ""
    scope = "AND " + options[:scope] unless options[:scope].blank? 
  
    # TODO: measure the performance of two queries to determine which one is better
    # this method returns more resources
    self.metaclass.send(:define_method, "more_feeds") do |user, idx, *args|
      depth = Intervals.size
      scope.concat " AND " + args.first if args.first
      while idx < depth
        from = Intervals[idx][:from].days.ago.to_s(:db)
        to = (Intervals[idx][:to] == 0)? Time.now.to_s(:db) : Intervals[idx][:to].days.ago.to_s(:db)
        #resources = []
        #user.friends.each do |f|
        #  resources.concat eval("#{type}").find_friend_viewable(:all, :conditions => ["user_id = ? AND created_at BETWEEN ? AND ? #{scope}", f.id, from, to])
        #end
        #resources.sort! { |y,x| x.created_at <=> y.created_at }
        privilege = "AND (privilege = 'all' OR privilege = 'friends')" if eval("#{type}").column_names.include?('privilege')
        sql = "select #{type_p}.* from #{type_p}, users, friendships where friendships.user_id = #{user.id} AND friendships.friend_id = users.id AND #{type_p}.user_id = users.id AND #{type_p}.created_at BETWEEN '#{from}' AND '#{to}' #{scope} #{privilege} ORDER BY #{type_p}.created_at DESC"
        resources = eval("#{type}").find_by_sql sql
        if resources.blank?
          idx = idx + 1
        else
          return [idx, resources]
        end
      end
      return [idx, nil]
    end

    # this method returns more resources between a period of time
    self.metaclass.send(:define_method, "feeds") do |user, idx, *args|
      depth = Intervals.size
      return nil if idx >= depth
      scope.concat " AND " + args.first if args.first
      from = Intervals[idx][:from].days.ago.to_s(:db)
      to = (Intervals[idx][:to] == 0)? Time.now.to_s(:db) : Intervals[idx][:to].days.ago.to_s(:db)
      #resources = []
      #user.friends.each do |f|
      #  resources.concat eval("#{type}").find_friend_viewable(:all, :conditions => ["created_at BETWEEN ? AND ? #{scope}", from, to])
      #end
      #resources.sort! { |y,x| x.created_at <=> y.created_at }
      privilege = "AND (privilege = 'all' OR privilege = 'friends')" if eval("#{type}").column_names.include?('privilege')
        sql = "select #{type_p}.* from #{type_p}, users, friendships where friendships.user_id = #{user.id} AND friendships.friend_id = users.id AND #{type_p}.user_id = users.id AND #{type_p}.created_at BETWEEN '#{from}' AND '#{to}' #{scope} #{privilege} ORDER BY #{type_p}.created_at DESC"
      resources = eval("#{type}").find_by_sql sql
      return resources
    end
  end
end

ActiveRecord::Base.extend(ResourceFeeder)
