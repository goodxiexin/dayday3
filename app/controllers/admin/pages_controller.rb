class Admin::PagesController < ApplicationController

  layout 'admin'

  before_filter :check_administrator_role

  def index
    @pages = Page.all
  end

  def show
    @page = Page.find(params[:id])
  end

  def new
    @page = Page.new
  end

  def edit
    @page = Page.find(params[:id])
  end

  def create
    @page = Page.new(params[:page])
    @page.save!
    flash[:notice] = 'Page Saved'
    redirect_to admin_page_url(@page)
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

  def update
    @page = Page.find(params[:id])
    @page.attributes = params[:page]
    @page.save!
    flash[:notice] = "Page Updated"
    redirect_to admin_page_url(@page)
  rescue ActiveRecord::RecordInvalid
    render :action => 'edit'
  end

  def destroy
    @page = Page.find(params[:id])
    if @page.destroy
      flash[:notice] = "Page Deleted"
    else
      flash[:error] = "There was a problem deleting the page"
    end
    redirect_to :action => 'index'
  end
end
