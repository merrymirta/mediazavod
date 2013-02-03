class MigrateCommentsTo6 < ActiveRecord::Migration
  def self.up
    migrate_plugin("comments", 6)
  end

  def self.down
    migrate_plugin("comments", 5)
  end
end
