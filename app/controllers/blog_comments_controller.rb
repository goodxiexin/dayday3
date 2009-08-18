class BlogCommentsController < ApplicationController

  before_filter :login_required

  def create
    @user = current_user
    @blog = Blog.find(params[:blog_id])
    @comment = Bcomment.new(params[:bcomment])
    @comment.user = @user
    @comment.blog = @blog

    respond_to do |format|
      if @comment.save
        format.html { render :partial => 'user_blogs/bcomment', :object => @comment }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        flash[:error] = "There was a problem saving this comment"
        format.html { render user_blog(:user_id => @user, :id => @blog) }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @blog = Blog.find(params[:blog_id])
    @comment = @blog.comments.find(params[:id])
    @comment.destroy
    render :nothing => true
  end

end
