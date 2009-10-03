# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include SubdomainSites

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :check_site_status
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user

  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end
 
    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end

    def require_admin
      unless current_user and current_user.access_level == "admin"
        store_location
        flash[:notice] = "You must be an administrator to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end


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
