class AddStaticPagesModule < ActiveRecord::Migration
  def self.up
    migrate_plugin("static_pages", 001)
  end

  def self.down
    migrate_plugin("static_pages", 0)
  end
end
