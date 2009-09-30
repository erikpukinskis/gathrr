require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Feed do
  it "should load entries" do
    feed = Feed.new(:url => "http://bunchuptest.blogspot.com/feeds/posts/default?alt=rss")
    feed.refresh
    feed.entries[0].content.should match(/Bunchup is going to be so much fun!/)
  end

  it "should strip spaces off the url" do
    feed = Feed.new(:url => "http://bunchuptest.blogspot.com/feeds/posts/default?alt=rss  ")
    feed.url.should == "http://bunchuptest.blogspot.com/feeds/posts/default?alt=rss"
  end

  it "should convert twitter @name to a feed" do
    feed = Feed.new(:twitter_username => "whoever")
    feed.url.should == "http://twitter.com/statuses/user_timeline/whoever.rss"
  end

  it "should find entries created after a certain time" do
    time = Time.now
    feed = Feed.create!

    before = Entry.new(:created_at => time - 1.minute)
    during = Entry.new(:created_at => time)
    after  = Entry.new(:created_at => time + 1.minute)
    feed.entries << before << during << after

    feed.entries_created_after(time).should == [during,after]
  end
end
