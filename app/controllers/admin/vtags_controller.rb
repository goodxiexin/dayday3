class VtagsController < ApplicationController
  # GET /vtags
  # GET /vtags.xml
  def index
    @vtags = Vtag.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vtags }
    end
  end

  # GET /vtags/1
  # GET /vtags/1.xml
  def show
    @vtag = Vtag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vtag }
    end
  end

  # GET /vtags/new
  # GET /vtags/new.xml
  def new
    @vtag = Vtag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vtag }
    end
  end

  # GET /vtags/1/edit
  def edit
    @vtag = Vtag.find(params[:id])
  end

  # POST /vtags
  # POST /vtags.xml
  def create
    @vtag = Vtag.new(params[:vtag])

    respond_to do |format|
      if @vtag.save
        flash[:notice] = 'Vtag was successfully created.'
        format.html { redirect_to(@vtag) }
        format.xml  { render :xml => @vtag, :status => :created, :location => @vtag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vtag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vtags/1
  # PUT /vtags/1.xml
  def update
    @vtag = Vtag.find(params[:id])

    respond_to do |format|
      if @vtag.update_attributes(params[:vtag])
        flash[:notice] = 'Vtag was successfully updated.'
        format.html { redirect_to(@vtag) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vtag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vtags/1
  # DELETE /vtags/1.xml
  def destroy
    @vtag = Vtag.find(params[:id])
    @vtag.destroy

    respond_to do |format|
      format.html { redirect_to(vtags_url) }
      format.xml  { head :ok }
    end
  end
end
