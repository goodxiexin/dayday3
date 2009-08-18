class PtagsController < ApplicationController
  # GET /ptags
  # GET /ptags.xml
  def index
    @ptags = Ptag.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ptags }
    end
  end

  # GET /ptags/1
  # GET /ptags/1.xml
  def show
    @ptag = Ptag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ptag }
    end
  end

  # GET /ptags/new
  # GET /ptags/new.xml
  def new
    @ptag = Ptag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ptag }
    end
  end

  # GET /ptags/1/edit
  def edit
    @ptag = Ptag.find(params[:id])
  end

  # POST /ptags
  # POST /ptags.xml
  def create
    @ptag = Ptag.new(params[:ptag])

    respond_to do |format|
      if @ptag.save
        flash[:notice] = 'Ptag was successfully created.'
        format.html { redirect_to(@ptag) }
        format.xml  { render :xml => @ptag, :status => :created, :location => @ptag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ptag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ptags/1
  # PUT /ptags/1.xml
  def update
    @ptag = Ptag.find(params[:id])

    respond_to do |format|
      if @ptag.update_attributes(params[:ptag])
        flash[:notice] = 'Ptag was successfully updated.'
        format.html { redirect_to(@ptag) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ptag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ptags/1
  # DELETE /ptags/1.xml
  def destroy
    @ptag = Ptag.find(params[:id])
    @ptag.destroy

    respond_to do |format|
      format.html { redirect_to(ptags_url) }
      format.xml  { head :ok }
    end
  end
end
