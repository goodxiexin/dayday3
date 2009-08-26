class BcommentsController < ApplicationController
  # GET /bcomments
  # GET /bcomments.xml
  def index
    @bcomments = Bcomment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bcomments }
    end
  end

  # GET /bcomments/1
  # GET /bcomments/1.xml
  def show
    @bcomment = Bcomment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bcomment }
    end
  end

  # GET /bcomments/new
  # GET /bcomments/new.xml
  def new
    @bcomment = Bcomment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bcomment }
    end
  end

  # GET /bcomments/1/edit
  def edit
    @bcomment = Bcomment.find(params[:id])
  end

  # POST /bcomments
  # POST /bcomments.xml
  def create
    @bcomment = Bcomment.new(params[:bcomment])

    respond_to do |format|
      if @bcomment.save
        flash[:notice] = 'Bcomment was successfully created.'
        format.html { redirect_to(@bcomment) }
        format.xml  { render :xml => @bcomment, :status => :created, :location => @bcomment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bcomment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bcomments/1
  # PUT /bcomments/1.xml
  def update
    @bcomment = Bcomment.find(params[:id])

    respond_to do |format|
      if @bcomment.update_attributes(params[:bcomment])
        flash[:notice] = 'Bcomment was successfully updated.'
        format.html { redirect_to(@bcomment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bcomment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bcomments/1
  # DELETE /bcomments/1.xml
  def destroy
    @bcomment = Bcomment.find(params[:id])
    @bcomment.destroy

    respond_to do |format|
      format.html { redirect_to(bcomments_url) }
      format.xml  { head :ok }
    end
  end
end
