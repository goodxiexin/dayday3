class VideoTagsController < ApplicationController

  before_filter :login_required

  def destroy
    @video = Video.find(params[:video_id])
    @video.tags.find(params[:id]).destroy
    render :nothing => true
  end 

end
