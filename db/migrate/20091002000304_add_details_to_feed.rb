class AddDetailsToFeed < ActiveRecord::Migration
  def self.up
    add_column :feeds, :link, :string
    add_column :feeds, :title, :string
  end

  def self.down
    remove_column :feeds, :title
    remove_column :feeds, :link
  end
end
