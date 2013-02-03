class AddTagsModule < ActiveRecord::Migration
  def self.up
    migrate_plugin("tags", 1)
  end

  def self.down
    migrate_plugin("tags", 0)
  end
end