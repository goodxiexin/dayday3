class Admin::PagesController < ApplicationController
  # GET /admin_pages
  # GET /admin_pages.xml
  def index
    @pages = Page.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admin_pages }
    end
  end

  # GET /admin_pages/1
  # GET /admin_pages/1.xml
  def show
    @pages = Page.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  # GET /admin_pages/new
  # GET /admin_pages/new.xml
  def new
    @pages = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  # GET /admin_pages/1/edit
  def edit
    @pages = Page.find(params[:id])
  end

  # POST /admin_pages
  # POST /admin_pages.xml
  def create
    @pages = Page.new(params[:pages])

    respond_to do |format|
      if @pages.save
        flash[:notice] = 'Admin::Pages was successfully created.'
        format.html { redirect_to(@pages) }
        format.xml  { render :xml => @pages, :status => :created, :location => @pages }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pages.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin_pages/1
  # PUT /admin_pages/1.xml
  def update
    @pages = Page.find(params[:id])

    respond_to do |format|
      if @pages.update_attributes(params[:pages])
        flash[:notice] = 'Admin::Pages was successfully updated.'
        format.html { redirect_to(@pages) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pages.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_pages/1
  # DELETE /admin_pages/1.xml
  def destroy
    @pages = Page.find(params[:id])
    @pages.destroy

    respond_to do |format|
      format.html { redirect_to(admin_pages_url) }
      format.xml  { head :ok }
    end
  end
end
