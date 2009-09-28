require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Feed do
  it "should load entries" do
    feed = Feed.new(:url => "http://bunchuptest.blogspot.com/feeds/posts/default?alt=rss")
    feed.refresh
    feed.entries[0].description.should match(/^Bunchup is going to be so much fun!/)
  end
end
