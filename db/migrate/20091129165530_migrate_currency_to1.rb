class MigrateCurrencyTo1 < ActiveRecord::Migration
  def self.up
    migrate_plugin("currency", 1)
  end

  def self.down
    migrate_plugin("currency", 0)
  end
end
