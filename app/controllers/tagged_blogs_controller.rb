class TaggedBlogsController < ApplicationController

  layout 'user'

  def index
    @user = User.find(params[:user_id])
    @blogs = Blog.tagged(params[:user_id], params[:page], 10)    
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @blogs }
    end
  end

end
