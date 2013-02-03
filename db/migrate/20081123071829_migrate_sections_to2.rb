class MigrateSectionsTo2 < ActiveRecord::Migration
  def self.up
    migrate_plugin("sections", 2)
  end

  def self.down
    migrate_plugin("sections", 1)
  end
end
