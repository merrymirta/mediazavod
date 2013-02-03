class AddPicturesModule < ActiveRecord::Migration
  def self.up
    migrate_plugin("pictures", 001)
  end

  def self.down
    migrate_plugin("pictures", 0)
  end
end
