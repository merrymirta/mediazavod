class RenameEditorsToUsers < ActiveRecord::Migration
  def self.up
    rename_table(:editors, :users)
  end

  def self.down
    rename_table(:users, :editors)
  end
end
