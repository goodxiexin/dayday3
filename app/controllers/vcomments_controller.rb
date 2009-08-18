class VcommentsController < ApplicationController
  # GET /vcomments
  # GET /vcomments.xml
  def index
    @vcomments = Vcomment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vcomments }
    end
  end

  # GET /vcomments/1
  # GET /vcomments/1.xml
  def show
    @vcomment = Vcomment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vcomment }
    end
  end

  # GET /vcomments/new
  # GET /vcomments/new.xml
  def new
    @vcomment = Vcomment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vcomment }
    end
  end

  # GET /vcomments/1/edit
  def edit
    @vcomment = Vcomment.find(params[:id])
  end

  # POST /vcomments
  # POST /vcomments.xml
  def create
    @vcomment = Vcomment.new(params[:vcomment])

    respond_to do |format|
      if @vcomment.save
        flash[:notice] = 'Vcomment was successfully created.'
        format.html { redirect_to(@vcomment) }
        format.xml  { render :xml => @vcomment, :status => :created, :location => @vcomment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vcomment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vcomments/1
  # PUT /vcomments/1.xml
  def update
    @vcomment = Vcomment.find(params[:id])

    respond_to do |format|
      if @vcomment.update_attributes(params[:vcomment])
        flash[:notice] = 'Vcomment was successfully updated.'
        format.html { redirect_to(@vcomment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vcomment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vcomments/1
  # DELETE /vcomments/1.xml
  def destroy
    @vcomment = Vcomment.find(params[:id])
    @vcomment.destroy

    respond_to do |format|
      format.html { redirect_to(vcomments_url) }
      format.xml  { head :ok }
    end
  end
end
