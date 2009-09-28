require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'feed_tools'

describe Entry do
  it "should make itself out of an item" do
    item = mock(FeedTools::FeedItem, :content => 'hi')
    Entry.from_item(item).content.should == "hi"
  end

  it "should close html tags" do
    Entry.new(:content => "<b>hi").clean_content.content.should == "<b>hi</b>"
  end

  it "should delete weird contentless tags, unless it's a br or img" do
    Entry.new(:content => "<br/><img/><em/>").clean_content.content.should == "<br/><img/>"
  end

end
