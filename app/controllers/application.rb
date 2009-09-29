# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include SubdomainSites

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :check_site_status

  protected
    def check_site_status
      unless site_subdomain == default_site_subdomain
        # TODO: this is where we could check to see if the site is active as well (paid, etc...)
        redirect_to default_site_url if current_site.nil? 
      end
    end  

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
