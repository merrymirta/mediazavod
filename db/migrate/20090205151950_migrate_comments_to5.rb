class MigrateCommentsTo5 < ActiveRecord::Migration
  def self.up
    migrate_plugin("comments", 5)
  end

  def self.down
    migrate_plugin("comments", 4)
  end
end
