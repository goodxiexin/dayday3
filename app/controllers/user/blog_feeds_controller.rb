class User::BlogFeedsController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :owner_required

  def index
    @user = resource_owner
    ret = Blog.more_feeds(@user, 0)
    @idx = ret[0] + 1
    @blogs = ret[1]
    render :action => 'index', :layout => params[:layout]
  end

  def get
    @user = resource_owner
    ret = Blog.more_feeds(@user, params[:idx].to_i)
    @idx = ret[0]
    @blogs = ret[1]
    if @blogs.blank?
      render :update do |page|
        page.replace_html 'more_feeds', '<h2> Cannot find any more blogs <h2>'
      end
    else
      render :update do |page|
        page.insert_html :bottom, 'feeds', :partial => 'bfeed', :collection => @blogs
        page.replace_html 'more_feeds', "#{link_to_remote "More..", :url => get_user_blog_feeds_url(@user, :idx => @idx + 1), :method => :get}"
      end
    end
  end

end
