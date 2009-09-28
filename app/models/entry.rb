class Entry < ActiveRecord::Base
  def Entry.from_item(item)
    Entry.new(:content => item.content)
  end

  def clean_content
    close_tags
    self
  end

  def close_tags
    return nil unless content
    open_tags = []
    tags = ""
    content.scan(/\<([^\>\s\/]+)[^\>\/]*?\>/).each { |t| open_tags.unshift(t) }
    content.scan(/\<\/([^\>\s\/]+)[^\>]*?\>/).each { |t| open_tags.slice!(open_tags.index(t)) }
    open_tags.each do |t| 
      tags += "</#{t}>"
    end
    content << tags
    nil
  end
end
