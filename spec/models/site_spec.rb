require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
  
def create_site(params = {})
  site = make_site(params)
  site.save
  site
end

def make_site(params = {})
  Site.new({
    :slug => "halo",
    :feed_list => "bad"
  }.merge(params))
end

describe Site do
  def with_two_urls
    create_site({:slug => "ev", :feed_list => "http://bunchup.us/feed1.rss\nhttp://bunchup.us/feed2.rss"})
  end

  describe "with a feed but no list" do
    before do
      @site = make_site({:feed_list => nil})
      @site.feeds << Feed.new
    end

    it do
      @site.should be_valid
    end
  end

  it "should be invalid without a slug" do
    make_site({:slug => ""}).should_not be_valid
    make_site({:slug => " "}).should_not be_valid
  end

  it "should be invalid without at least one feed" do
    make_site({:feed_list => ""}).should_not be_valid
  end

  it "should not import bad sites" do
    site = create_site({:feed_list => "ando\n@bunchuptest"})
    site.feeds.count.should == 1
  end
    

  describe "with 18 entries" do
    before do
      feed = Feed.create!
      (1..18).each do |num|
        feed.entries << Entry.new(:content => num.to_s)
      end
      @site = create_site
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
      @site = Site.new
    end

    it do
      @site.should_not be_loaded
    end
  end

  describe "after load" do
    before do
      queue_in_rss("hi", Time.now)
      @site = create_site
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
      @original = create_site({:slug => "taken"})
      @imitator = Site.new(:slug => "taken")
    end
 
    it do
      @original.should be_valid
    end

    it do
      @imitator.should_not be_valid
    end
  end

  def queue_in_rss(content, date)
    fake_item = mock(:content => content, :published => date, :link => nil, :title => nil)
    @fake_feed_tools_feed = mock(:items => [], :link => nil, :title => nil)
    @fake_feed_tools_feed.stub!(:items).and_return([fake_item])
    FeedTools::Feed.stub!(:open).and_return(@fake_feed_tools_feed)
  end

  describe "when feeds always return one new fake item" do
    before do
      @site = create_site
      @site.feeds << Feed.create!
    end

    it "shouldn't be ready before the actual refresh" do
      @site.refresh
      @site.waiting_for_refresh.should be_true
    end

    it "should be ready after the refresh" do
      queue_in_rss("bo", Time.now)
      @site.refresh_now
      @site.waiting_for_refresh.should be_false
    end
  end

  describe "with two feeds with interleaved entries" do
    before do
      @first_entry = Entry.new(:date => Date.parse("9/28/2009"))
      @third_entry = Entry.new(:date => Date.parse("9/30/2009"))
      @second_entry = Entry.new(:date => Date.parse("9/29/2009"))

      @site = create_site
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
