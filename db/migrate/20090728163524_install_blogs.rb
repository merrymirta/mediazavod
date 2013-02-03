class InstallBlogs < ActiveRecord::Migration
  def self.up
    migrate_plugin("blogs", 1)
  end

  def self.down
    migrate_plugin("blogs", 0)
  end
end
