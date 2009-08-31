class User::StatusesController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :owner_required, :only => [:new, :create, :destroy]

  def new
    @user = resource_owner
    @latest_status = @user.latest_status
  end

  def create
    @user = resource_owner
    @status = Status.new(params[:status])
    @status.user = @user

    if params[:home].to_i == 1
      if @status.save
        render :update do |page|
          page.replace_html "latest_status", :inline => "<%= distance_of_time_in_words_to_now(@user.latest_status.created_at) %> ago: <%= @user.latest_status.content %>"
          page.visual_effect :highlight, 'latest_status', :duration => 2
          page << "$('status_content').value = '';"
        end
      else
        render :update do |page|
          page << "alert('something error occurred, try it later')"
        end
      end
    else
      if @status.save
        render :update do |page|
          page.insert_html :top, 'statuses', :partial => 'status', :object => @status
          page << "$('status_content').value = '';"
        end
      end
    end
  end

  def index
    @user = resource_owner
    @statuses = @user.statuses 
  end

  def destroy
    @status = Status.find(params[:id])
    @status.destroy
    render :nothing => true
  rescue ActiveRecord::RecordNotFound
    render :text => 'status not found' 
  end

end
