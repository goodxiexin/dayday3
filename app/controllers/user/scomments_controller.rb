class User::ScommentsController < ApplicationController

  before_filter :login_required

  before_filter :owner_required, :only => [:destroy]

  def create
    @status = Status.find(params[:status_id])
    @comment = Scomment.new(params[:scomment])
    @comment.user = current_user
    @comment.status = @status
    if @comment.save
      render :partial => 'scomment', :object => @comment
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'status not found'
  end

  def destroy
    @status = Status.find(params[:status_id])
    @comment = @status.comments.find(params[:id])
    @comment.destroy
    render :nothing => true
  rescue ActiveRecord::RecordNotFound
    render :text => 'status not found'
  end

  def index
    @status = Status.find(params[:status_id])
    @comments = @status.comments.find_user_viewable(current_user.id, :all)
    render :partial => 'scomment', :collection => @comments
  rescue ActiveRecord::RecordNotFound
    render :text => 'status not found'
  end


end
