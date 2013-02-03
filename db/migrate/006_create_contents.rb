class CreateContents < ActiveRecord::Migration
  def self.up
    rename_table :pages, :contents
    add_column :contents, :type, :string
  end

  def self.down
    remove_column :contents, :type
    rename_table :contents, :pages
  end
end
