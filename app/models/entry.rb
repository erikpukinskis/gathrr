require 'rubygems'
require 'hpricot'

class Entry < ActiveRecord::Base
  def Entry.from_item(item)
    Entry.new(:content => item.content)
  end

  def clean_content
    close_tags
    self
  end

  def close_tags
    self.content = Hpricot(self.content, :fixup_tags => true).to_html
  end
end
