class Entry < ActiveRecord::Base
  def Entry.from_item(item)
    Entry.new(:content => item.content)
  end
end
