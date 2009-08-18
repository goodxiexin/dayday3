class PhotoDigsController < ApplicationController

  def create
    @photo = Photo.find(params[:photo_id])

    if @photo.digs.find_by_user_id(current_user.id)
      render :update do |page|
        page << "alert('You have dugg before');"
      end
    else
      @photo.digs.create(:user_id => current_user.id)
      render :update do |page|
        page << "var count = parseInt($('digs_count').innerHTML) + 1; $('digs_count').innerHTML = count;"
      end
    end
  end

end
