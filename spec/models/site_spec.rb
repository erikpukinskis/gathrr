require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Site do
  def with_two_feeds
    Site.create!(:slug => "ev", :feed_list => "http://bunchup.us/feed1.rss\nhttp://bunchup.us/feed2.rss")
  end

  it "should create a bunch of feeds" do
    lambda {
      with_two_feeds
    }.should change(Feed, :count).by(2)
  end

  it "should know the feeds belong to it" do
    with_two_feeds.feeds.count.should == 2
  end

  it "should create the proper feeds" do
    site = with_two_feeds
    site.feeds[0].url.should == "http://bunchup.us/feed1.rss"
    site.feeds[1].url.should == "http://bunchup.us/feed2.rss"
  end
end
