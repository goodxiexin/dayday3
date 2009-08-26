class User::BtagsController < ApplicationController

  before_filter :login_required

  before_filter :owner_required, :only => [:destroy]

  def destroy
    @tag = Btag.find(params[:id])
    @tag.destroy
    render :nothing => true
  rescue ActiveRecord::RecordNotFound
    render :text => 'btag not found'
  end

end
