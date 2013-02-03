class MigrateStaticPagesTo2 < ActiveRecord::Migration
  def self.up
    migrate_plugin("static_pages", 2)
  end

  def self.down
    migrate_plugin("static_pages", 1)
  end
end
