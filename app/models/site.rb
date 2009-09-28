class Site < ActiveRecord::Base
  has_many :feeds, :dependent => :destroy
  has_many :entries, :through => :feeds

  def feed_list

  end

  def feed_list=(feed_string)
    if self.new_record?
      @feed_string = feed_string
    else
      self.create_feeds(feed_string)  # parse tags, create tags & taggings
    end
  end

  def create_feeds(feed_string)
    urls = feed_string.split("\n")
    urls.each {|url| feeds << Feed.new(:url => url) }
  end

  def after_create
    self.feed_list = @feed_string if @feed_string
  end

  def refresh
    feeds.each {|feed| feed.refresh}
  end
end
