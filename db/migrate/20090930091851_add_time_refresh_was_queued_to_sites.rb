class AddTimeRefreshWasQueuedToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :time_refresh_was_queued, :datetime
  end

  def self.down
    remove_column :sites, :time_refresh_was_queued
  end
end
