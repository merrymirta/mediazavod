class InstallSettings < ActiveRecord::Migration
  def self.up
    migrate_plugin("settings", 1)
  end

  def self.down
    migrate_plugin("settings", 0)
  end
end
