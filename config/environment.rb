# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
# RAILS_GEM_VERSION = '2.3.3' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "authlogic"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end

class Object
  def print_methods
    methods.sort.each {|i| print "#{i}\n"}
    nil
  end
end 

class Time
  def to_human
    distance_in_minutes = (((Time.now - self).abs)/60).ceil
    case distance_in_minutes
      when 0..1           then time = "#{distance_in_minutes} minute ago"
      when 0..59          then time = "#{distance_in_minutes} minutes ago"
      when 60..90         then time = "1 hour ago"
      when 90..1440       then time = "#{(distance_in_minutes.to_f / 60.0).round} hours ago"
      else time = strftime("%-1I:%M %p %b #{day.ordinal}")
    end
    return time
  end
end

class Numeric
	def ordinal
		self.to_s + ( (10...20).include?(self) ? 'th' : %w{ th st nd rd th th th th th th }[self % 10] )
	end
end

class ActiveRecord::Errors
  CUSTOM_PREFIX = '^'
 
  def full_messages(options = {})
    full_messages = []
 
    @errors.each_key do |attr|
      @errors[attr].each do |message|
        next unless message
 
        if attr == "base"
          full_messages << message
        elsif message.mb_chars[0..(CUSTOM_PREFIX.size-1)] == CUSTOM_PREFIX
          full_messages << message.mb_chars[(CUSTOM_PREFIX.size)..-1]
        else
          #key = :"activerecord.att.#{@base.class.name.underscore.to_sym}.#{attr}"
          attr_name = @base.class.human_attribute_name(attr)
          full_messages << attr_name + ' ' + message
        end
 
      end
    end
    full_messages
  end
 
end
