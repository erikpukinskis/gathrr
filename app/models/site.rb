
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
  validates_uniqueness_of :slug, :message => "^That url is taken"
  validates_format_of :slug, :with => /[A-Za-z0-9]/
  attr_accessor :feed_list

  def validate
    feed_list = @feed_stringfe
    unless feeds.length > 0 or /[A-Za-z0-9]/.match(@feed_string) 
      errors.add(:feed_list, "^You need to enter at least one feed")
    end
  end

  def after_create
    self.feed_list = @feed_string if @feed_string
    refresh
  end

  def entries_by_date
    entries.sort
  end

  def pages
    (entries_by_date.reverse / 15)
  end

  def feed_list
    @feed_string
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
        feeds << Feed.new({:twitter_username => without_at.strip})
      elsif /^http:\/\//.match(id)
        feeds << Feed.new({:url => id})
      end
    end
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
      Delayed::Job.enqueue SiteRefreshJob.new(id, false), 1
    end
    refreshing
  end

  def refresh_now
    print "Mmm, refreshing!\n"
    update_attributes(:last_refresh => Time.now)
    feeds.each {|feed| feed.refresh}
    update_attributes(:waiting_for_refresh => false)
  end

  def Site.queue_another(wait_until = nil)
    Delayed::Job.enqueue SiteRefreshJob.new(nil, true), 2, wait_until
  end
end
