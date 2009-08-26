class BtagsController < ApplicationController

  layout 'admin'

  before_filter :check_administrator_role

  # GET /btags
  # GET /btags.xml
  def index
    @btags = Btag.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @btags }
    end
  end

  # GET /btags/1
  # GET /btags/1.xml
  def show
    @btag = Btag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @btag }
    end
  end

  # GET /btags/new
  # GET /btags/new.xml
  def new
    @btag = Btag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @btag }
    end
  end

  # GET /btags/1/edit
  def edit
    @btag = Btag.find(params[:id])
  end

  # POST /btags
  # POST /btags.xml
  def create
    @btag = Btag.new(params[:btag])

    respond_to do |format|
      if @btag.save
        flash[:notice] = 'Btag was successfully created.'
        format.html { redirect_to(@btag) }
        format.xml  { render :xml => @btag, :status => :created, :location => @btag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @btag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /btags/1
  # PUT /btags/1.xml
  def update
    @btag = Btag.find(params[:id])

    respond_to do |format|
      if @btag.update_attributes(params[:btag])
        flash[:notice] = 'Btag was successfully updated.'
        format.html { redirect_to(@btag) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @btag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /btags/1
  # DELETE /btags/1.xml
  def destroy
    @btag = Btag.find(params[:id])
    @btag.destroy

    respond_to do |format|
      format.html { redirect_to(btags_url) }
      format.xml  { head :ok }
    end
  end
end
