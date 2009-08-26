class User::StatusFeedsController < ApplicationController

  before_filter :login_required

  def get
    @user = User.find(params[:user_id])
    ret = Status.more_feeds(@user, params[:idx].to_i)
    @idx = ret[0]
    @statuses = ret[1]
    if @statuses.blank?
      render :update do |page|
        page.replace_html 'more_feeds', '<h2> Cannot find any more statuses <h2>'
      end
    else
      render :update do |page|
        page.insert_html :bottom, 'feeds', :partial => 'sfeed', :collection => @statuses
        page.replace_html 'more_feeds', "#{link_to_remote "More..", :url => get_user_status_feeds_url(@user, :idx => @idx + 1), :method => :get}"
      end
    end
  end

end
