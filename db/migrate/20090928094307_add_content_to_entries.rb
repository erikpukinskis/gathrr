class AddContentToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :content, :text
  end

  def self.down
    remove_column :entries, :content
  end
end
