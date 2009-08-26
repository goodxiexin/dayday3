class BdigsController < ApplicationController
  # GET /bdigs
  # GET /bdigs.xml
  def index
    @bdigs = Bdig.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bdigs }
    end
  end

  # GET /bdigs/1
  # GET /bdigs/1.xml
  def show
    @bdig = Bdig.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bdig }
    end
  end

  # GET /bdigs/new
  # GET /bdigs/new.xml
  def new
    @bdig = Bdig.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bdig }
    end
  end

  # GET /bdigs/1/edit
  def edit
    @bdig = Bdig.find(params[:id])
  end

  # POST /bdigs
  # POST /bdigs.xml
  def create
    @bdig = Bdig.new(params[:bdig])

    respond_to do |format|
      if @bdig.save
        flash[:notice] = 'Bdig was successfully created.'
        format.html { redirect_to(@bdig) }
        format.xml  { render :xml => @bdig, :status => :created, :location => @bdig }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bdig.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bdigs/1
  # PUT /bdigs/1.xml
  def update
    @bdig = Bdig.find(params[:id])

    respond_to do |format|
      if @bdig.update_attributes(params[:bdig])
        flash[:notice] = 'Bdig was successfully updated.'
        format.html { redirect_to(@bdig) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bdig.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bdigs/1
  # DELETE /bdigs/1.xml
  def destroy
    @bdig = Bdig.find(params[:id])
    @bdig.destroy

    respond_to do |format|
      format.html { redirect_to(bdigs_url) }
      format.xml  { head :ok }
    end
  end
end
