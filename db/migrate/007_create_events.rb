class CreateEvents < ActiveRecord::Migration
  def self.up
    add_column :contents, :excerpt, :text
  end

  def self.down
    remove_column :contents, :excerpt
  end
end
