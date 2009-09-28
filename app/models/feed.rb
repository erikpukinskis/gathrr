require 'feed_tools'

class Feed < ActiveRecord::Base
  belongs_to :site
  has_many :entries, :dependent => :destroy

  def url=(url)
    super(url.strip)
  end

  def refresh
    feed = FeedTools::Feed.open(url)

    feed.items.each do |item|
      entry = Entry.from_item(item).clean_content
      entries << entry
    end 
  end
end
