class ScommentsController < ApplicationController
  # GET /scomments
  # GET /scomments.xml
  def index
    @scomments = Scomment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @scomments }
    end
  end

  # GET /scomments/1
  # GET /scomments/1.xml
  def show
    @scomment = Scomment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @scomment }
    end
  end

  # GET /scomments/new
  # GET /scomments/new.xml
  def new
    @scomment = Scomment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @scomment }
    end
  end

  # GET /scomments/1/edit
  def edit
    @scomment = Scomment.find(params[:id])
  end

  # POST /scomments
  # POST /scomments.xml
  def create
    @scomment = Scomment.new(params[:scomment])

    respond_to do |format|
      if @scomment.save
        flash[:notice] = 'Scomment was successfully created.'
        format.html { redirect_to(@scomment) }
        format.xml  { render :xml => @scomment, :status => :created, :location => @scomment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @scomment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /scomments/1
  # PUT /scomments/1.xml
  def update
    @scomment = Scomment.find(params[:id])

    respond_to do |format|
      if @scomment.update_attributes(params[:scomment])
        flash[:notice] = 'Scomment was successfully updated.'
        format.html { redirect_to(@scomment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @scomment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /scomments/1
  # DELETE /scomments/1.xml
  def destroy
    @scomment = Scomment.find(params[:id])
    @scomment.destroy

    respond_to do |format|
      format.html { redirect_to(scomments_url) }
      format.xml  { head :ok }
    end
  end
end
