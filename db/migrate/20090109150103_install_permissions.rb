class InstallPermissions < ActiveRecord::Migration
  def self.up
    migrate_plugin("permissions", 1)
  end

  def self.down
    migrate_plugin("permissions", 0)
  end
end
