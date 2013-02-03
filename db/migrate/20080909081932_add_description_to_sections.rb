class AddDescriptionToSections < ActiveRecord::Migration
  def self.up
    add_column :sections, :description, :string
  end

  def self.down
    remove_column :sections, :description
  end
end
