class Site < ActiveRecord::Base
  has_many :feeds

  def feed_list

  end

  def feed_list=(feed_string)
    if self.new_record?
      @feed_string = feed_string
    else
      self.create_feeds(feed_string)  # parse tags, create tags & taggings
    end
  end

  def create_feeds(feed_string)
      
  end

  def after_create
    self.feed_list = @feed_string if @feed_string
  end
end
