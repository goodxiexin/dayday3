class WallMessagesController < ApplicationController
  # GET /wall_messages
  # GET /wall_messages.xml
  def index
    @wall_messages = WallMessage.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @wall_messages }
    end
  end

  # GET /wall_messages/1
  # GET /wall_messages/1.xml
  def show
    @wall_message = WallMessage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @wall_message }
    end
  end

  # GET /wall_messages/new
  # GET /wall_messages/new.xml
  def new
    @wall_message = WallMessage.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @wall_message }
    end
  end

  # GET /wall_messages/1/edit
  def edit
    @wall_message = WallMessage.find(params[:id])
  end

  # POST /wall_messages
  # POST /wall_messages.xml
  def create
    @wall_message = WallMessage.new(params[:wall_message])

    respond_to do |format|
      if @wall_message.save
        flash[:notice] = 'WallMessage was successfully created.'
        format.html { redirect_to(@wall_message) }
        format.xml  { render :xml => @wall_message, :status => :created, :location => @wall_message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @wall_message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /wall_messages/1
  # PUT /wall_messages/1.xml
  def update
    @wall_message = WallMessage.find(params[:id])

    respond_to do |format|
      if @wall_message.update_attributes(params[:wall_message])
        flash[:notice] = 'WallMessage was successfully updated.'
        format.html { redirect_to(@wall_message) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @wall_message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /wall_messages/1
  # DELETE /wall_messages/1.xml
  def destroy
    @wall_message = WallMessage.find(params[:id])
    @wall_message.destroy

    respond_to do |format|
      format.html { redirect_to(wall_messages_url) }
      format.xml  { head :ok }
    end
  end
end
