class VisitorRecordsController < ApplicationController
  # GET /visitor_records
  # GET /visitor_records.xml
  def index
    @visitor_records = VisitorRecords.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @visitor_records }
    end
  end

  # GET /visitor_records/1
  # GET /visitor_records/1.xml
  def show
    @visitor_records = VisitorRecords.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @visitor_records }
    end
  end

  # GET /visitor_records/new
  # GET /visitor_records/new.xml
  def new
    @visitor_records = VisitorRecords.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @visitor_records }
    end
  end

  # GET /visitor_records/1/edit
  def edit
    @visitor_records = VisitorRecords.find(params[:id])
  end

  # POST /visitor_records
  # POST /visitor_records.xml
  def create
    @visitor_records = VisitorRecords.new(params[:visitor_records])

    respond_to do |format|
      if @visitor_records.save
        flash[:notice] = 'VisitorRecords was successfully created.'
        format.html { redirect_to(@visitor_records) }
        format.xml  { render :xml => @visitor_records, :status => :created, :location => @visitor_records }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @visitor_records.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /visitor_records/1
  # PUT /visitor_records/1.xml
  def update
    @visitor_records = VisitorRecords.find(params[:id])

    respond_to do |format|
      if @visitor_records.update_attributes(params[:visitor_records])
        flash[:notice] = 'VisitorRecords was successfully updated.'
        format.html { redirect_to(@visitor_records) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @visitor_records.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /visitor_records/1
  # DELETE /visitor_records/1.xml
  def destroy
    @visitor_records = VisitorRecords.find(params[:id])
    @visitor_records.destroy

    respond_to do |format|
      format.html { redirect_to(visitor_records_url) }
      format.xml  { head :ok }
    end
  end
end
