require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "#{RAILS_ROOT}/app/models/feed.rb"

describe RSS::Rss::Channel::Item do
  it "should be convertable to a hash" do
    item = RSS::Rss::Channel::Item.new(:description => "hi")
    item.to_h[:description].should == "hi"
  end
end
