require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'feed_tools'

describe Entry do
  describe "made from an item" do
    before do
      @now = Time.now
      item = mock(FeedTools::FeedItem, :content => 'hi', :published => @now)
      @entry = Entry.from_item(item)
    end

    it "should load content" do   
      @entry.content.should == "hi"
    end

    it "should get the published date" do   
      @entry.date.should == @now
    end
  end

  it "should close html tags" do
    Entry.new(:content => "<b>hi").clean_content.content.should == "<b>hi</b>"
  end

end
