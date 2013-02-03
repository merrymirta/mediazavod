class MigratePagesTo3 < ActiveRecord::Migration
  def self.up
    migrate_plugin("static_pages", 3)
  end

  def self.down
    migrate_plugin("static_pages", 2)
  end
end
