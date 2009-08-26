class User::VtagsController < ApplicationController

  before_filter :login_required

  before_filter :owner_required, :only => [:destroy]

  def destroy
    @tag = Vtag.find(params[:id]) 
    @tag.destroy
    render :nothing => true
  rescue ActiveRecord::RecordNotFound
    render :text => 'vtag not found'
  end 

end
