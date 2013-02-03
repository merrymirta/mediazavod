class AddOwnerToShorty < ActiveRecord::Migration
  def self.up
    add_column :shorties, :author_id, :integer
  end

  def self.down
    remove_column :shorties, :author_id
  end
end
