class User::TaggedVideosController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :record_visiting

  def index
    @user = resource_owner
    @videos = Video.tagged(params[:user_id]).paginate :page => params[:page], :per_page => 10  
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @videos }
    end
  end


end
