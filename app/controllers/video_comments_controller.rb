class VideoCommentsController < ApplicationController

  before_filter :login_required

  def create
    @user = current_user
    @video = Video.find(params[:video_id])
    @comment = Vcomment.new(params[:vcomment])
    @comment.user = @user
    @comment.video = @video

    respond_to do |format|
      if @comment.save
        format.html { render :partial => 'vcomment', :object => @comment }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        flash[:error] = "There was a problem saving this comment"
        format.html { render user_video(@user, @blog) }
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
