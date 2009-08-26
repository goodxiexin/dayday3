class VdigsController < ApplicationController
  # GET /vdigs
  # GET /vdigs.xml
  def index
    @vdigs = Vdig.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vdigs }
    end
  end

  # GET /vdigs/1
  # GET /vdigs/1.xml
  def show
    @vdig = Vdig.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vdig }
    end
  end

  # GET /vdigs/new
  # GET /vdigs/new.xml
  def new
    @vdig = Vdig.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vdig }
    end
  end

  # GET /vdigs/1/edit
  def edit
    @vdig = Vdig.find(params[:id])
  end

  # POST /vdigs
  # POST /vdigs.xml
  def create
    @vdig = Vdig.new(params[:vdig])

    respond_to do |format|
      if @vdig.save
        flash[:notice] = 'Vdig was successfully created.'
        format.html { redirect_to(@vdig) }
        format.xml  { render :xml => @vdig, :status => :created, :location => @vdig }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vdig.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vdigs/1
  # PUT /vdigs/1.xml
  def update
    @vdig = Vdig.find(params[:id])

    respond_to do |format|
      if @vdig.update_attributes(params[:vdig])
        flash[:notice] = 'Vdig was successfully updated.'
        format.html { redirect_to(@vdig) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vdig.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vdigs/1
  # DELETE /vdigs/1.xml
  def destroy
    @vdig = Vdig.find(params[:id])
    @vdig.destroy

    respond_to do |format|
      format.html { redirect_to(vdigs_url) }
      format.xml  { head :ok }
    end
  end
end
