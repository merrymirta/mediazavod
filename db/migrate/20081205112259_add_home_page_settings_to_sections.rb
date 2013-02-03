class AddHomePageSettingsToSections < ActiveRecord::Migration
  def self.up
    add_column :sections, :articles_at_homepage, :integer, :default => 4
    add_column :sections, :shorties_at_homepage, :integer, :default => 4

    add_column :sections, :articles_at_section, :integer, :default => 6
    add_column :sections, :shorties_at_section, :integer, :default => 10
  end

  def self.down
    remove_column :sections, :articles_at_homepage
    remove_column :sections, :shorties_at_homepage

    remove_column :sections, :articles_at_section
    remove_column :sections, :shorties_at_section
  end
end
