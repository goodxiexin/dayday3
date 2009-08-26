class BlogObserver < ActiveRecord::Observer

  def before_update(blog)
    @was_draft = blog.draft
    blog.logger.info "before: #{@was_draft}"
  end

  def after_update(blog)
    blog.logger.info "after: #{blog.draft}"
    if @was_draft and !blog.draft
      ActiveRecord::Base::connection().update("UPDATE blogs SET created_at = '#{Time.now.to_s(:db)}' WHERE id = '#{blog.id}'")
      pos = blog.user.blogs[0].position + 1 
      ActiveRecord::Base::connection().update("UPDATE blogs SET position = '#{pos}' WHERE id = '#{blog.id}'")
    end
  end

end

