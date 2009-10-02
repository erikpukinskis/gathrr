class SiteRefreshJob < Struct.new(:site, :continuous)
  def perform
    site.refresh_now
    Site.queue_another if continuous
  end    
end 
