class MigrateCommentsTo2 < ActiveRecord::Migration
  def self.up
    migrate_plugin("comments", 2)
  end

  def self.down
    migrate_plugin("comments", 1)
  end
end
