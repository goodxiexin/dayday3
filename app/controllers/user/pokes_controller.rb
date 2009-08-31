class User::PokesController < ApplicationController

  layout 'user'

  before_filter :owner_required

  def index
    @user = resource_owner
    @pokes = @user.pokes.paginate :page => params[:page], :per_page => 10
  end

  def new
    @user = resource_owner
    @receiver = User.find(params[:receiver_id])
    render :action => 'new', :layout => false
  rescue ActiveRecord::RecordNotFound
    render :text => 'user not found'
  end

  def create
    @user = resource_owner
    @poke = Poke.new(params[:poke])
    @poke.sender = @user
    if @poke.save
      render :update do |page|
        page << "facebox.close();"
      end
    else
      render :update do |page|
        page << "$('error').innerHTML = 'an error occurred, try it later';"
      end
    end
  end

  def destroy
  end

  def destroy_all
  end

end
