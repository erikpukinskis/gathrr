require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'

class RSS::Rss::Channel::Item
  def to_h
    {:description => description}
  end
end

class Feed < ActiveRecord::Base
  belongs_to :site
  has_many :entries

  def url=(url)
    super(url.strip)
  end

  def refresh
    content = "" # raw content of rss feed will be loaded here
    open(url) {|s| content = s.read }
    rss = RSS::Parser.parse(content, false)
    rss.items.each do |item| 
      entry = Entry.new(item.to_h)
      entries << entry
    end
  end
end
