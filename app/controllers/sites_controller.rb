class SitesController < ApplicationController
  before_filter :require_admin, :except => [:show, :new, :create, :default]

  def do_show
    @site = current_site ? current_site : Site.find(params[:id])
    @page = params[:page] ? params[:page].to_i : 1

    if @site.loaded?
#      response.headers['Cache-Control'] = 'public, max-age=900' if RAILS_ENV == 'production'
      respond_to do |format|
        format.html { render :action => "show" }
        format.xml  { render :xml => @site }
      end
    else
      render :action => 'loading'
    end
  end

  def default
    if current_site
      do_show
    else
      @site = Site.new

      respond_to do |format|
        format.html { render :action => "new" }
        format.xml  { render :xml => @site }
      end
    end
  end

  # GET /sites
  # GET /sites.xml
  def index
    @sites = Site.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sites }
    end
  end

  # GET /sites/1
  # GET /sites/1.xml
  def show
    do_show
  end

  # GET /sites/1/newest_entries
  def newest_entries
    @site = Site.find(params[:id])

    unless @site.waiting_for_refresh
      render :nothing => true, :status => 200
    else
      render :nothing => true, :status => 304
    end
  end



  # GET /sites/new
  # GET /sites/new.xml
  def new
    @site = Site.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @site }
    end
  end

  # GET /sites/1/edit
  def edit
    @site = Site.find(params[:id])
  end

  # POST /sites
  # POST /sites.xml
  def create
    @site = Site.new(params[:site])

    respond_to do |format|
      if @site.save
        format.html { redirect_to(@site) }
        format.xml  { render :xml => @site, :status => :created, :location => @site }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  def refresh
    @site = Site.find(params[:id])
    @site.refresh_now
    redirect_to url_for(@site)
  end

  # PUT /sites/1
  # PUT /sites/1.xml
  def update
    @site = Site.find(params[:id])

    respond_to do |format|
      if @site.update_attributes(params[:site])
        flash[:notice] = 'Site was successfully updated.'
        format.html { redirect_to(@site) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.xml
  def destroy
    @site = Site.find(params[:id])
    @site.destroy

    respond_to do |format|
      format.html { redirect_to(sites_url) }
      format.xml  { head :ok }
    end
  end
end
