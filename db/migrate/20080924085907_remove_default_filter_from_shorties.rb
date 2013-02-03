class RemoveDefaultFilterFromShorties < ActiveRecord::Migration
  def self.up
    change_column :shorties, :filter, :integer, :default => nil
  end

  def self.down
    change_column :shorties, :filter, :integer, :default => 0
  end
end
