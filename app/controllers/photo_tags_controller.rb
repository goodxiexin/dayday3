class PhotoTagsController < ApplicationController

  before_filter :login_required

  def create
    @user = current_user
    @photo = Photo.find(params[:photo_id])
    @tag = Ptag.new(params[:tag])
    @tag.user = @user
    
    respond_to do |format|
      if @tag.save
        format.html { render :partial => 'album_photos/ptag', :object => @tag }
        format.xml  { render :xml => @tag }
      else
        format.html { logger.error "error" }
        format.xml  { render :xml => @tag.errors }
      end
    end 
  end

  def destroy
    @tag = Ptag.find(params[:id])
    @tag.destroy
    render :nothing => true
  end

end
