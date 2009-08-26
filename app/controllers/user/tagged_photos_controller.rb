class User::TaggedPhotosController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :record_visiting

  def index
    @user = resource_owner
    @photos = Photo.tagged(params[:user_id]).paginate :page => params[:page], :per_page => 12  
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @photos }
    end
  end

end
