require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Site do
  def with_two_urls
    Site.create!(:slug => "ev", :feed_list => "http://bunchup.us/feed1.rss\nhttp://bunchup.us/feed2.rss")
  end

  describe "with 18 entries" do
    before do
      feed = Feed.create!
      (1..18).each do |num|
        feed.entries << Entry.new
      end
      @site = Site.create!
      @site.feeds << feed
    end

    it "first page should have 15 entries" do
      @site.pages[0].length.should == 15
    end

    it "second page should have 3 entries" do
      @site.pages[1].length.should == 3
    end

    it "should have 2 pages" do
      @site.pages.count.should == 2
    end

  end

  describe "before load" do
    before do
      @site = Site.create!
    end

    it do
      @site.should_not be_loaded
    end
  end

  describe "after load" do
    before do
      @site = Site.create!
      @site.refresh_now
    end
    
    it do
      @site.should be_loaded
    end
  end

  it "should create a bunch of feeds" do
    lambda {
      with_two_urls
    }.should change(Feed, :count).by(2)
  end

  it "should know the feeds belong to it" do
    with_two_urls.feeds.count.should == 2
  end

  it "should create the proper feeds" do
    site = with_two_urls
    site.feeds[0].url.should == "http://bunchup.us/feed1.rss"
    site.feeds[1].url.should == "http://bunchup.us/feed2.rss"
  end

  describe "with the same slug as an existing site" do
    before do
      @original = Site.create!(:slug => "taken")
      @imitator = Site.new(:slug => "taken")
    end
 
    it do
      @original.should be_valid
    end

    it do
      @imitator.should_not be_valid
    end
  end

  def queue_in_rss(content)
    fake_item = mock(:content => content, :published => Time.now - 1.year)
    @fake_feed_tools_feed.stub!(:items).and_return([fake_item])
  end

  describe "when feeds always return one new fake item" do
    before do
      @fake_feed_tools_feed = mock(:items => [])
      FeedTools::Feed.stub!(:open).and_return(@fake_feed_tools_feed)
      @site = Site.create!
      @site.feeds << Feed.create!
    end

    it "should find first entries after initial refresh" do
      queue_in_rss("boo")
      @site.refresh_now
      @site.newest_entries.length.should == 1
      @site.newest_entries.first.content.should == "boo"
    end

    it "should find additional entries after new refresh" do
      queue_in_rss("old")
      @site.refresh_now
      queue_in_rss("new")
      sleep 1
      @site.refresh_now
      @site.entries.length.should == 2
      @site.newest_entries.length.should == 1
      @site.newest_entries.first.content.should == "new"
    end

    it "shouldn't be ready before the actual refresh" do
      @site.refresh
      @site.waiting_for_refresh.should be_true
    end

    it "should be ready after the refresh" do
      @site.refresh_now
      @site.waiting_for_refresh.should be_false
    end
  end

  it "should find new entries" do
    refresh = Time.now
    feed = Feed.create!
    before = Entry.new(:created_at => refresh - 1.minute)
    after = Entry.new(:created_at => refresh + 1.minute)
    feed.entries << before << after
    site = Site.create!(:last_refresh => refresh)
    site.feeds << feed

    site.newest_entries.should == [after]
  end


  describe "with two feeds with interleaved entries" do
    before do
      @first_entry = Entry.new(:date => Date.parse("9/28/2009"))
      @third_entry = Entry.new(:date => Date.parse("9/30/2009"))
      @second_entry = Entry.new(:date => Date.parse("9/29/2009"))

      @site = Site.create!
      @site.feeds << Feed.new
      @site.feeds << Feed.new

      @site.feeds[0].entries << @first_entry
      @site.feeds[0].entries << @third_entry
      @site.feeds[1].entries << @second_entry
    end

    it "should put the entries in order" do
      @site.entries_by_date[0].should == @first_entry
      @site.entries_by_date[1].should == @second_entry
      @site.entries_by_date[2].should == @third_entry
    end
  end
end
