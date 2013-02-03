class MigrateWidgetsTo2 < ActiveRecord::Migration
  def self.up
    migrate_plugin("widgets", 2)
  end

  def self.down
    migrate_plugin("widgets", 0)
  end
end
