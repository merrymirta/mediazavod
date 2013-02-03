class AddDisplayAtHomePageToSection < ActiveRecord::Migration
  def self.up
    add_column :sections, :display_at_homepage, :boolean, :default => true
  end

  def self.down
    remove_column :sections, :display_at_homepage
  end
end
