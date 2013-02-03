class MigrateCommentsTo4 < ActiveRecord::Migration
  def self.up
    migrate_plugin("comments", 4)
  end

  def self.down
    migrate_plugin("comments", 3)
  end
end
