class User::BdigsController < ApplicationController

  before_filter :login_required

  def create
    @blog = Blog.find(params[:blog_id])
   
    if @blog.digs.find_by_user_id(current_user.id)
      render :update do |page|
        page << "alert('You have dugg before');"
      end
    else
      @blog.digs.create(:user_id => current_user.id)
      render :update do |page|
        page << "var count = parseInt($('digs_count_#{@blog.id}').innerHTML) + 1; $('digs_count_#{@blog.id}').innerHTML = count;"      
      end
    end 
  end

end
