# 
# Inspired by 
#   http://dev.rubyonrails.org/svn/rails/plugins/site_location/lib/site_location.rb
# 
module SubdomainSites
  def self.included( controller )
    controller.helper_method(:site_domain, :site_subdomain, :site_url, :current_site, :default_site_subdomain, :default_site_url)
  end
  
  protected
    
    # TODO: need to handle www as well
    def default_site_subdomain
      ''
    end
    
    def site_url( site = nil, use_ssl = request.ssl? )
      site_subdomain = site ? site.slug : default_site_subdomain
      http_protocol(use_ssl) + site_host(site_subdomain)
    end
    
    def site_host( subdomain )
      site_host = ''
      site_host << subdomain + '.'
      site_host << site_domain
    end
 
    def site_domain
      site_domain = ''
      site_domain << request.domain + request.port_string
    end
 
    def site_subdomain
      request.subdomains.first || ''
    end
    
    def default_site_url( use_ssl = request.ssl? )
      http_protocol(use_ssl) + site_domain
    end      
          
    def current_site
      return nil if site_subdomain == ''
      Site.find_by_slug(site_subdomain)
    end
    
    def http_protocol( use_ssl = request.ssl? )
      (use_ssl ? "https://" : "http://")
    end 
end
