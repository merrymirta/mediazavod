class AddCustomTextToSections < ActiveRecord::Migration
  def self.up
    add_column :sections, :additional_text, :text
  end

  def self.down
    remove_column :sections, :additional_text
  end
end
