class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.string :title
      t.string :link
      t.text :description
      t.datetime :date

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
