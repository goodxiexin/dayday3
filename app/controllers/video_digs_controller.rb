class VideoDigsController < ApplicationController

  before_filter :login_required

  def create
    @video = Video.find(params[:video_id])
   
    if @video.digs.find_by_user_id(current_user.id)
      render :update do |page|
        page << "alert('You have dugg before');"
      end
    else
      @video.digs.create(:user_id => current_user.id)
      render :update do |page|
        page << "var count = parseInt($('digs_count_#{@video.id}').innerHTML) + 1; $('digs_count_#{@video.id}').innerHTML = count;"      
      end
    end 
  end


end
