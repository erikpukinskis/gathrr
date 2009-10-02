class SiteRefreshJob
  attr_accessor :site, :continuous

  def initialize(site, continuous)
    self.site = site
    self.continuous = continuous
  end

  def perform
    frequency = 1.hour
    if @site
      @site = Site.find_by_id(@site)
      @site.refresh_now
    else
      @site = Site.find(:first, :order => "last_refresh")
      if @site.last_refresh.localtime + frequency < Time.now
        @site.refresh_now if @site
      else
        wait_until = @site.last_refresh.localtime + frequency
        print "no feeds need refreshing.  waiting until #{wait_until}\n"
      end
    end
    Site.queue_another(wait_until) if continuous
  end    
end 
