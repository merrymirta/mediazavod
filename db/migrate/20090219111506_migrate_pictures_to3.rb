class MigratePicturesTo3 < ActiveRecord::Migration
  def self.up
    migrate_plugin("pictures", 3)
  end

  def self.down
    migrate_plugin("pictures", 2)
  end
end
