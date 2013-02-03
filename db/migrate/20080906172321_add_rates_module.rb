class AddRatesModule < ActiveRecord::Migration
  def self.up
    migrate_plugin("rates", 001)
  end

  def self.down
    migrate_plugin("rates", 0)
  end
end
