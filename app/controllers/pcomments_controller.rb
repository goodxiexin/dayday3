class PcommentsController < ApplicationController
  # GET /pcomments
  # GET /pcomments.xml
  def index
    @pcomments = Pcomment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pcomments }
    end
  end

  # GET /pcomments/1
  # GET /pcomments/1.xml
  def show
    @pcomment = Pcomment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pcomment }
    end
  end

  # GET /pcomments/new
  # GET /pcomments/new.xml
  def new
    @pcomment = Pcomment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pcomment }
    end
  end

  # GET /pcomments/1/edit
  def edit
    @pcomment = Pcomment.find(params[:id])
  end

  # POST /pcomments
  # POST /pcomments.xml
  def create
    @pcomment = Pcomment.new(params[:pcomment])

    respond_to do |format|
      if @pcomment.save
        flash[:notice] = 'Pcomment was successfully created.'
        format.html { redirect_to(@pcomment) }
        format.xml  { render :xml => @pcomment, :status => :created, :location => @pcomment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pcomment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pcomments/1
  # PUT /pcomments/1.xml
  def update
    @pcomment = Pcomment.find(params[:id])

    respond_to do |format|
      if @pcomment.update_attributes(params[:pcomment])
        flash[:notice] = 'Pcomment was successfully updated.'
        format.html { redirect_to(@pcomment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pcomment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pcomments/1
  # DELETE /pcomments/1.xml
  def destroy
    @pcomment = Pcomment.find(params[:id])
    @pcomment.destroy

    respond_to do |format|
      format.html { redirect_to(pcomments_url) }
      format.xml  { head :ok }
    end
  end
end
