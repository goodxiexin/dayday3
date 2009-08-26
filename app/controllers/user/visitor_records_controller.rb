class User::VisitorRecordsController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :owner_required

  before_filter :record_visiting

  def index
    @user = User.find(params[:user_id])
    @visitor_records = @user.visitor_records.paginate :page => params[:page], :per_page => 15
  end

end
