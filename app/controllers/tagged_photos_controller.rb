class TaggedPhotosController < ApplicationController

  layout 'user'

  def index
    @user = User.find(params[:user_id])
    @photos = Photo.tagged(params[:user_id], params[:page], 12)    
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @blogs }
    end
  end

end
