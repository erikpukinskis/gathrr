class AddStuffToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :slug, :string
  end

  def self.down
    remove_column :sites, :slug
  end
end
