class UserStatusesController < ApplicationController

  layout 'user'

  before_filter :login_required, :except => [:index, :show]

  def index
    @user = User.find(params[:user_id])
    @statuses = @user.statuses
    respond_to do |format|
      format.html
      format.xml { render :xml => @statuses }
    end
  end

  def show
    @status = Status.find(params[:id])
    
    respond_to do |format|
      format.html
      format.xml {render :xml => @status}
    end
  end

  def create
    @status = Photo.new(params[:photo])
    
    respond_to do |format|
      if @status.save
        format.html
        format.xml {render :xml => @status}
      else
        format.html {render :action => 'new' }
        format.xml {render :xml => @status.errors, :status => :unprocessable_entity }
      end
    end
  end

end
