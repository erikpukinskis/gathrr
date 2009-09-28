class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.string :url
      t.integer :site_id

      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
  end
end
