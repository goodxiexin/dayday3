class User::FriendsController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :owner_required, :only => [:index, :destroy, :search]

  def index
    @user = resource_owner
    case params[:term]
    when 'name'
      @friends = @user.friends.paginate :page => params[:page], :per_page => 10, :order => 'login ASC'
    when 'game'
      game = Game.find(params[:game_id])
      friends = @user.friends.find_all {|f| f.games.include?(game) }
      @friends = friends.paginate :page => params[:page], :per_page => 10, :order => 'login ASC'
    when 'time'
      @friends = @user.friends.paginate :page => params[:page], :per_page => 10, :order => 'created_at DESC'
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @friends }
    end
  end

  def confirm_destroy
    @user= resource_owner
    @friend = User.find(params[:id])
    render :action => 'confirm_destroy', :layout => false
  rescue ActiveRecord::RecordNotFound
    render :text => 'friend not found' 
  end

  def destroy
    @user = resource_owner
    @friendship = Friendship.find(:first, :conditions => {:user_id => @user.id, :friend_id => params[:id]})
    if session[:validation_text] == params[:validation_text]
      @friendship.destroy
      render :update do |page|
        page << "facebox.close();$('friend_#{params[:id]}').remove();"
      end
    else
      render :update do |page|
        page << "$('error').innerHTML = validation code error';" 
      end
    end
  rescue ActiveRecord::RecordNotFound
    render :text => 'friend not found'
  end

  def search
    @user = resource_owner
    friends = @user.friends.find_all {|f| f.login.include?(params[:key]) }
    @friends = friends.paginate :page => params[:page], :per_page => 10, :order => 'login ASC'
    @remote = {:update => 'friends', :url => {:action => 'search', :term => 'name', :key => params[:key]}}
    respond_to do |format|
      format.html { render :partial => 'friends', :object => @friends }
      format.xml { render :xml => @friends.xml }
    end
  end

  def new
    @user = User.find(params[:friend_id])
  end

end
