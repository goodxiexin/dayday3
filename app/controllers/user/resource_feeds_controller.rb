class User::ResourceFeedsController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :owner_required

  def index
    @user = resource_owner  
    @friends = @user.friends[0..8]
    # friend suggesion
    # pending request
    @resource_feeds = []
    @resource_feeds.concat Status.feeds(@user, 0)
    @resource_feeds.concat Blog.feeds(@user, 0)  
    @resource_feeds.concat Video.feeds(@user, 0)
    @resource_feeds.concat Album.feeds(@user, 0)
    @resource_feeds.sort! { |x,y| y.created_at <=> x.created_at }
    @idx = 1 
  end

  def get
    @user = resource_owner
    @idx = params[:idx].to_i
    @resource_feeds = []
    if params[:game_id].blank?
      while @resource_feeds.blank? and @idx < 4
        @resource_feeds.concat Status.feeds(@user, @idx)
        @resource_feeds.concat Blog.feeds(@user, @idx)
        @resource_feeds.concat Video.feeds(@user, @idx)
        @resource_feeds.concat Album.feeds(@user, @idx)
        @idx = @idx + 1
      end
    else
      args = "game_id = #{params[:game_id]}"
      while @resource_feeds.blank? and @idx < 4
        @resource_feeds.concat Blog.feeds(@user, @idx, args)
        @resource_feeds.concat Video.feeds(@user, @idx, args)
        @resource_feeds.concat Album.feeds(@user, @idx, args)
        @idx = @idx + 1
      end
    end
    if @resource_feeds.blank?
      render :update do |page|
        page.replace_html 'more_feeds', '<h2> Cannot find any more resource feeds </h2>'
      end
    else
      @resource_feeds.sort! { |x,y| y.created_at <=> x.created_at }
      render :update do |page|
        page.insert_html :bottom, 'feeds', :partial => 'resource_feed', :collection => @resource_feeds
        page.replace_html 'more_feeds', "#{link_to_remote "More..", :url => get_user_resource_feeds_url(@user, :idx => @idx, :game_id => params[:game_id]), :method => :get}"
      end
    end
  end
 
end
