class AlbumFeedsController < ApplicationController

  layout 'user'

  def index
    @user = User.find(params[:user_id])
    sql = ["select albums.* from albums, users, friendships " +
          "where friendships.user_id = #{@user.id} AND friendships.friend_id = users.id AND albums.user_id = users.id AND albums.updated_at > ?" +
          "ORDER BY albums.updated_at DESC", 1.week.ago.to_s(:db)]
    @albums = Album.paginate_by_sql sql, :page => params[:page], :per_page => 10
  end

end
