class MigrateCommonsTo1 < ActiveRecord::Migration
  def self.up
    migrate_plugin("commons", 1)
  end

  def self.down
    migrate_plugin("commons", 0)
  end
end
