class User::PcommentsController < ApplicationController

  before_filter :login_required

  before_filter :owner_required, :only => [:destroy]

  def create
    @photo = Photo.find(params[:photo_id])
    @album = @photo.album
    @comment = Pcomment.new(params[:pcomment])
    @comment.user = current_user
    @comment.photo = @photo
    if @comment.save
      render :partial => 'pcomment', :object => @comment
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'photo not found'
  end

  def destroy
    @photo = Photo.find(params[:photo_id])
    @comment = @photo.comments.find(params[:id])
    @comment.destroy
    render :nothing => true
  rescue ActiveRecord::RecordNotFound
    render :text => 'photo not found'
  end

end
