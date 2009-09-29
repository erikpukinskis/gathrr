class Site < ActiveRecord::Base
  has_many :feeds, :dependent => :destroy
  has_many :entries, :through => :feeds
  
  def feed_list

  end

  def entries_by_date
    entries.sort
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

  def refresh
    feeds.each {|feed| feed.refresh}
  end
end
