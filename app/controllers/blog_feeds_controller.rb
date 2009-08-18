class BlogFeedsController < ApplicationController

  layout 'user'

  def index
    @user = User.find(params[:user_id])
    sql = ["select blogs.* from blogs, users, friendships " +
          "where friendships.user_id = #{@user.id} AND friendships.friend_id = users.id AND blogs.user_id = users.id AND blogs.updated_at > ?" +
          "ORDER BY blogs.updated_at DESC", 1.week.ago.to_s(:db)]
    @blogs = Blog.paginate_by_sql sql, :page => params[:page], :per_page => 10
  end

end
