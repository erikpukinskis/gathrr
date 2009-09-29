class AddRefreshmentToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :waiting_for_refresh, :boolean
    add_column :sites, :last_refresh, :datetime
  end

  def self.down
    remove_column :sites, :last_refresh
    remove_column :sites, :waiting_for_refresh
  end
end
