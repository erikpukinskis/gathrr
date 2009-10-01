class SiteRefreshJob < Struct.new(:site, :continuous)
  def perform
    site.refresh_now
    Site.queue_another if continuous
  end    
end  

class Array
  def / len
    a = []
    each_with_index do |x,i|
      a << [] if i % len == 0
      a.last << x
    end
    a
  end
end

class Site < ActiveRecord::Base
  has_many :feeds, :dependent => :destroy
  has_many :entries, :through => :feeds
  validates_uniqueness_of :slug, :message => "That url is taken"

  def feed_list
    
  end

  def entries_by_date
    entries.sort
  end

  def pages
    (entries_by_date.reverse / 15)
  end

  def feed_list=(feed_string)
    if self.new_record?
      @feed_string = feed_string
    else
      self.create_feeds(feed_string)  # parse tags, create tags & taggings
    end
  end

  def create_feeds(feed_string)
    identifiers = feed_string.split("\n")
    identifiers.each do |id|  
      if id.first == '@'
        without_at = id[1,id.length]
        params = {:twitter_username => without_at.strip}
      else 
        params = {:url => id}
      end
      feeds << Feed.new(params)
    end
  end

  def after_create
    self.feed_list = @feed_string if @feed_string
  end

  def stale
    last_refresh == nil or last_refresh < 1.hour.ago
  end

  def loaded?
    !!last_refresh
  end

  def refresh
    refreshing = !waiting_for_refresh && stale
    if refreshing
      update_attributes(:waiting_for_refresh => true, :time_refresh_was_queued => Time.now)
      Delayed::Job.enqueue SiteRefreshJob.new(:site => self, :continuous => false)
      send_later(:refresh_now)
    end
    refreshing
  end

  def refresh_now
    update_attributes(:last_refresh => Time.now)
    feeds.each {|feed| feed.refresh}
    update_attributes(:waiting_for_refresh => false)
  end

  def newest_entries
    feeds.inject([]) do |newest,feed|
      newest + feed.entries_created_after(last_refresh)
    end
  end 

  def refresh_and_queue_another
    refresh_now
    Site.queue_another
  end

  def Site.queue_another
    site = Site.find(:first, :conditions => ["last_refresh < ", 1.hour.ago.utc], 
                     :order => "last_refresh")
    site.send_later(:refresh_and_queue_another)
  end
end
