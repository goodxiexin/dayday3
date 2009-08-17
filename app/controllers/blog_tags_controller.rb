class BlogTagsController < ApplicationController

  before_filter :login_required

  def destroy
    @blog = Blog.find(params[:blog_id])
    @blog.tags.find(params[:id]).destroy
    render :nothing => true
  end

end
