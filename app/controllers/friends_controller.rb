class FriendsController < ApplicationController

  layout 'user'

  before_filter :login_required, :except => [:index, :show]

  def index
    @user = User.find(params[:user_id], :include => [:friendships => :friend])
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

  def destroy
    @user = current_user
    @user.friendships.find_by_friend_id(params[:id]).destroy
   
    respond_to do |format|
      format.html { render :nothing => true }
      format.xml { head :ok }
    end
  end

  def search
    @user = current_user
    friends = @user.friends.find_all {|f| f.login.include?(params[:key]) }
    @friends = friends.paginate :page => params[:page], :per_page => 10, :order => 'login ASC'
    @remote = {:update => 'friends', :url => {:action => 'search', :term => 'name', :key => params[:key]}}
      
    respond_to do |format|
      format.html { render :partial => 'friends', :object => @friends }
      format.xml { render :xml => @friends.xml }
    end
  end

end
