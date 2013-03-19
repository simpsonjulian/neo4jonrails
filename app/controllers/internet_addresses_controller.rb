class InternetAddressesController < ApplicationController
  # GET /internet_addresses
  # GET /internet_addresses.json
  def index
    @internet_addresses = InternetAddress.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @internet_addresses }
    end
  end

  # GET /internet_addresses/1
  # GET /internet_addresses/1.json
  def show
    @internet_address = InternetAddress.find_by_integer(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @internet_address }
    end
  end

  # GET /internet_addresses/new
  # GET /internet_addresses/new.json
  def new
    @internet_address = InternetAddress.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @internet_address }
    end
  end

  # GET /internet_addresses/1/edit
  def edit
    @internet_address = InternetAddress.find_by_integer(params[:id])
  end

  # POST /internet_addresses
  # POST /internet_addresses.json
  def create
    parameters = params[:internet_address]
    @internet_address = InternetAddress.new(parameters[:number], parameters[:version])

    respond_to do |format|

      if @internet_address.save
        format.html { redirect_to @internet_address, :notice => 'Internet address was successfully created.' }
        format.json { render :json => @internet_address, :status => :created, :location => @internet_address }
      else
        format.html { render :action => "new" }
        format.json { render :json => @internet_address.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /internet_addresses/1
  # PUT /internet_addresses/1.json
  def update
    @internet_address = InternetAddress.find_by_integer(params[:id])

    respond_to do |format|
      if @internet_address.update_attributes(params[:internet_address])
        format.html { redirect_to @internet_address, :notice => 'Internet address was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @internet_address.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /internet_addresses/1
  # DELETE /internet_addresses/1.json
  def destroy
    @internet_address = InternetAddress.find_by_integer(params[:id])
    @internet_address.destroy

    respond_to do |format|
      format.html { redirect_to internet_addresses_url }
      format.json { head :no_content }
    end
  end
end
