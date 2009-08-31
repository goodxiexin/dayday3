class User::VcommentsController < ApplicationController

  before_filter :login_required

  before_filter :owner_required, :only => [:destroy]

  def create
    @video = Video.find(params[:video_id])
    @comment = Vcomment.new(params[:vcomment])
    @comment.user = current_user
    @comment.video = @video
    if @comment.save
      render :partial => 'vcomment', :object => @comment
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'video not found'
  end

  def destroy
    @video = Video.find(params[:video_id])
    @comment = @video.comments.find(params[:id])
    @comment.destroy
    render :nothing => true
  rescue ActiveRecord::RecordNotFound
    render :text => 'video not found'
  end

  def index
    @video = Video.find(params[:video_id])
    @comments = @video.comments.find_user_viewable(current_user.id, :all)
    render :partial => 'vcomment', :collection => @comments
  rescue ActiveRecord::RecordNotFound
    render :text => 'video not found'
  end  

end
