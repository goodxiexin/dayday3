class User::AlbumFeedsController < ApplicationController

  layout 'user'

  before_filter :login_required

  before_filter :owner_required

  def index
    @user = resource_owner
    ret = Album.more_feeds(@user, 0)
    @idx = ret[0] + 1
    @albums = ret[1]
  end     
    
  def get
    @user = resource_owner
    ret = Album.more_feeds(@user, params[:idx].to_i)
    @idx = ret[0]
    @albums = ret[1]
    if @albums.blank?
      render :update do |page|
        page.replace_html 'more_feeds', '<h2> Cannot find any more albums <h2>'
      end
    else
      render :update do |page|
        page.insert_html :bottom, 'feeds', :partial => 'afeed', :collection => @albums
        page.replace_html 'more_feeds', "#{link_to_remote "More..", :url => get_user_album_feeds_url(@user, :idx => @idx + 1), :method => :get}"
      end 
    end
  end 

end
