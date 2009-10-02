require 'feed_tools'

class Feed < ActiveRecord::Base
  belongs_to :site
  has_many :entries, :dependent => :destroy
  attr_accessor :twitter_username

  def after_initialize
    if twitter_username
      self.url = "http://twitter.com/statuses/user_timeline/#{twitter_username}.rss"
    end
  end

  def service_link
    "<a href=\"#{link}\">Twitter</a>"
  end

  def url=(url)
    super(url.strip)
  end

  def refresh
    feed = FeedTools::Feed.open(url)
    update_attributes(:link => feed.link, :title => feed.title)

    feed.items.each do |item|
      entry = Entry.from_item(item).clean_content
      entries << entry
    end 
  end

  def entries_created_after(time)
    Entry.find(:all, :conditions => ["feed_id = ? AND created_at >= ?", id, time.utc])
  end
end
