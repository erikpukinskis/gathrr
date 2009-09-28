require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'feed_tools'

describe Entry do
  it "should make itself out of an item" do
    item = mock(FeedTools::FeedItem, :content => 'hi')
    Entry.from_item(item).content.should == "hi"
  end

  it "should close html tags" do
    Entry.new(:content => "<b>hi").content.should == "<b>hi</b>"
  end
end
