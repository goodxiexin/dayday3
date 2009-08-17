class IconsController < ApplicationController

  layout 'admin'
  
  before_filter :check_administrator_role

  # GET /icons
  # GET /icons.xml
  def index
    @icons = Icon.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @icons }
    end
  end

  # GET /icons/1
  # GET /icons/1.xml
  def show
    @icon = Icon.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @icon }
    end
  end

  # GET /icons/new
  # GET /icons/new.xml
  def new
    @icon = Icon.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @icon }
    end
  end

  # GET /icons/1/edit
  def edit
    @icon = Icon.find(params[:id])
  end

  # POST /icons
  # POST /icons.xml
  def create
    @icon = Icon.new(params[:icon])
    @icon.uploaded_data = params[:icon][:uploaded_data]
    respond_to do |format|
      if @icon.save
        logger.error 'success'
        flash[:notice] = 'Icon was successfully created.'
        format.html { redirect_to(@icon) }
        format.xml  { render :xml => @icon, :status => :created, :location => @icon }
      else
        logger.error 'error'
        flash.now[:error] = 'there was a problem saving this photo'
        format.html { render :action => "new" }
        format.xml  { render :xml => @icon.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /icons/1
  # PUT /icons/1.xml
  def update
    @icon = Icon.find(params[:id])

    respond_to do |format|
      if @icon.update_attributes(params[:icon])
        flash[:notice] = 'Icon was successfully updated.'
        format.html { redirect_to(@icon) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @icon.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /icons/1
  # DELETE /icons/1.xml
  def destroy
    @icon = Icon.find(params[:id])
    @icon.destroy

    respond_to do |format|
      format.html { redirect_to(icons_url) }
      format.xml  { head :ok }
    end
  end
end
