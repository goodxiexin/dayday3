class PhotoCommentsController < ApplicationController

  before_filter :login_required

  def create
    @user = current_user
    @photo = Photo.find(params[:photo_id])
    @album = @photo.album
    @comment = Pcomment.new(params[:comment])
    @comment.user = @user
    @comment.photo = @photo

    respond_to do |format|
      if @comment.save
        format.html { render :partial => 'album_photos/pcomment', :object => @comment }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        flash[:error] = "There was a problem saving this comment"
        format.html { redirect_to album_photo(:album_id => @album, :id => @photo) }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @photo = Photo.find(params[:photo_id])
    @comment = @photo.comments.find(params[:id])
    @comment.destroy
    render :nothing => true
  end

end
