class User::VideoFeedsController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :owner_required

  def index 
    @user = resource_owner
    ret = Video.more_feeds(@user, 0)
    @idx = ret[0] + 1
    @videos = ret[1]
  end 
        
  def get
    @user = resource_owner
    ret = Video.more_feeds(@user, params[:idx].to_i)
    @idx = ret[0]
    @videos = ret[1]
    if @videos.blank?
      render :update do |page|
        page.replace_html 'more_feeds', '<h2> Cannot find any more videos <h2>'
      end
    else
      render :update do |page|
        page.insert_html :bottom, 'feeds', :partial => 'vfeed', :collection => @videos
        page.replace_html 'more_feeds', "#{link_to_remote "More..", :url => get_user_video_feeds_url(@user, :idx => @idx + 1), :method => :get}"
      end
    end
  end
  

end
