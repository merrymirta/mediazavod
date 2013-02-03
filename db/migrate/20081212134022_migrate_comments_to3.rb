class MigrateCommentsTo3 < ActiveRecord::Migration
  def self.up
    migrate_plugin("comments", 3)
  end

  def self.down
    migrate_plugin("comments", 2)
  end
end
