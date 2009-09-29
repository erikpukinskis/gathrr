require 'rubygems'
require 'hpricot'

class Entry < ActiveRecord::Base
  def Entry.from_item(item)
    Entry.new(:content => item.content, :date => item.published)
  end

  def clean_content
    close_tags
    self
  end

  def close_tags
    self.content = Hpricot(self.content, :fixup_tags => true).to_html
  end

  def <=>(other)
    if date and other.date
      date <=> other.date
    else 0 end
  end
end
