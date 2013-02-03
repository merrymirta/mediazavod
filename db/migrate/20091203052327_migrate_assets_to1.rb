class MigrateAssetsTo1 < ActiveRecord::Migration
  def self.up
    migrate_plugin("assets", 1)
  end

  def self.down
    migrate_plugin("assets", 0)
  end
end
