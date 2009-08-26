class User::BcommentsController < ApplicationController

  before_filter :login_required

  before_filter :owner_required, :only => [:destroy]

  def create
    @blog = Blog.find(params[:blog_id])
    @comment = Bcomment.new(params[:bcomment])
    @comment.user = current_user
    @comment.blog = @blog
    if @comment.save
      BcommentNotification.create(:user_id => current_user.id, :receiver_id => bcomment.receiver_id, :blog_id => bcomment.blog.id)
      render :partial => 'bcomment', :object => @comment
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'blog not found'
  end

  def destroy
    @blog = Blog.find(params[:blog_id])
    @comment = @blog.comments.find(params[:id])
    @comment.destroy
    render :nothing => true
  rescue ActiveRecord::RecordNotFound
    render :text => 'blog not found'
  end

  def index
    @blog = Blog.find(params[:blog_id])
    @comments = @blog.comments
    render :partial => 'bcomment', :collection => @comments
  rescue ActiveRecord::RecordNotFound
    render :text => 'blog not found'
  end

end
