require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Feed do
  describe "from twitter" do
    before do 
      @feed = Feed.create!(:twitter_username => "bunchuptest")
      @feed.refresh
    end

    it do
      @feed.service.should == 'twitter'
    end

    it "should have a good service link" do
      @feed.service_link.should == "<a href=\"#{@feed.link}\">Twitter</a>"
    end

    it "should have a link" do
      @feed.link.should == "http://twitter.com/bunchuptest"
    end
  end

  describe "from rss" do
    before :all do
      @feed = Feed.new(:url => "http://bunchuptest.blogspot.com/feeds/posts/default?alt=rss")
      @feed.refresh
    end

    it do
      @feed.title.should == "Bunchup Test"
    end

    it "should load entries" do
      @feed.entries[0].content.should match(/Bunchup is going to be so much fun!/)
    end

    it "have a service link" do
      @feed.service_link.should == "<a href=\"http://bunchuptest.blogspot.com/\">Bunchup Test</a>"
    end
  end

  def queue_in_rss(content, date)
    @rss ||= []
    @rss << mock(:content => content, :published => date, :link => nil, :title => nil)
    fake_feed_tools_feed = mock(:link => nil, :title => nil)
    fake_feed_tools_feed.stub!(:items).and_return(@rss)
    FeedTools::Feed.stub!(:open).and_return(fake_feed_tools_feed)
  end

  it "should not put in items a second time" do
    @rss = nil
    feed = Feed.create!
    refresh = Time.now
    queue_in_rss("boo", refresh - 1.day)
    feed.refresh
    queue_in_rss("baz", refresh + 1.day)
    feed.refresh
    feed.entries.count.should == 2
  end

  it "should find the newest entry" do
    time = Time.now
    second = Entry.new(:date => time)
    first = Entry.new(:date => time - 1.day)
    feed = Feed.create!
    feed.entries << second << first
    feed.newest_entry.should == second
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
