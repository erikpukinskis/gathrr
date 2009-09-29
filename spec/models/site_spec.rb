require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Site do
  def with_two_urls
    Site.create!(:slug => "ev", :feed_list => "http://bunchup.us/feed1.rss\nhttp://bunchup.us/feed2.rss")
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
