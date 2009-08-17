class PdigsController < ApplicationController
  # GET /pdigs
  # GET /pdigs.xml
  def index
    @pdigs = Pdig.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pdigs }
    end
  end

  # GET /pdigs/1
  # GET /pdigs/1.xml
  def show
    @pdig = Pdig.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pdig }
    end
  end

  # GET /pdigs/new
  # GET /pdigs/new.xml
  def new
    @pdig = Pdig.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pdig }
    end
  end

  # GET /pdigs/1/edit
  def edit
    @pdig = Pdig.find(params[:id])
  end

  # POST /pdigs
  # POST /pdigs.xml
  def create
    @pdig = Pdig.new(params[:pdig])

    respond_to do |format|
      if @pdig.save
        flash[:notice] = 'Pdig was successfully created.'
        format.html { redirect_to(@pdig) }
        format.xml  { render :xml => @pdig, :status => :created, :location => @pdig }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pdig.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pdigs/1
  # PUT /pdigs/1.xml
  def update
    @pdig = Pdig.find(params[:id])

    respond_to do |format|
      if @pdig.update_attributes(params[:pdig])
        flash[:notice] = 'Pdig was successfully updated.'
        format.html { redirect_to(@pdig) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pdig.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pdigs/1
  # DELETE /pdigs/1.xml
  def destroy
    @pdig = Pdig.find(params[:id])
    @pdig.destroy

    respond_to do |format|
      format.html { redirect_to(pdigs_url) }
      format.xml  { head :ok }
    end
  end
end
