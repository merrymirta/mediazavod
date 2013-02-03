class MigrateTagsTo2 < ActiveRecord::Migration
  def self.up
    migrate_plugin("tags", 2)
  end

  def self.down
    migrate_plugin("tags", 1)
  end
end
