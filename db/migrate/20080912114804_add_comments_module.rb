class AddCommentsModule < ActiveRecord::Migration
  def self.up
    migrate_plugin("comments", 001)
  end

  def self.down
    migrate_plugin("comments", 0)
  end
end
