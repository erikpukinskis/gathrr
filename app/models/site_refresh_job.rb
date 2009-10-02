class SiteRefreshJob < Struct.new(:site, :continuous)
  def perform
    unless site
      site = Site.find(:first, #:conditions => ["last_refresh < ", 1.hour.ago.utc], 
                       :order => "last_refresh")
    end

    site.refresh_now
    Site.queue_another if continuous
  end    
end 
