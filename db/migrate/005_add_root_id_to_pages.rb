class AddRootIdToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :root_id, :integer
  end

  def self.down
    remove_column :pages, :root_id
  end
end
