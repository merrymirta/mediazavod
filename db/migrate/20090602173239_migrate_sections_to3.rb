class MigrateSectionsTo3 < ActiveRecord::Migration
  def self.up
    migrate_plugin("sections", 3)
  end

  def self.down
    migrate_plugin("sections", 2)
  end
end
