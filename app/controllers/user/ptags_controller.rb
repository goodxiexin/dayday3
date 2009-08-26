class User::PtagsController < ApplicationController

  before_filter :login_required

  before_filter :owner_required, :only => [:destroy]

  def create
    @user = resource_owner
    @photo = Photo.find(params[:photo_id])
    @tag = Ptag.new(params[:tag])
    @tag.user = current_user
    if @tag.save
      render :partial => 'ptag', :object => @tag
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'photo not found' 
  end

  def destroy
    @tag = Ptag.find(params[:id])
    @tag.destroy
    render :nothing => true
  rescue ActiveRecord::RecordNotFound
    render :text => 'ptag not found'
  end

end
