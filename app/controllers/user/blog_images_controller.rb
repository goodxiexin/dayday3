class User::BlogImagesController < ApplicationController
  
  def upload
    @photo = Photo.new(params[:photo])
    @photo.save
    responds_to_parent do
      render :update do |page|
        page << "facebox.close();nicUploadButton.statusCb({'done':1,'url':'#{@photo.public_filename}', 'width':'#{@photo.width}'});"  
      end
    end
  end

end
