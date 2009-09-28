class AddFeedItToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :feed_id, :integer
  end

  def self.down
    remove_column :entries, :feed_id
  end
end
