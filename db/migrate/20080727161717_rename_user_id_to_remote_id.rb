class RenameUserIdToRemoteId < ActiveRecord::Migration
  def self.up
    rename_column :editors, :user_id, :remote_id
  end

  def self.down
    rename_column :editors, :remote_id, :user_id
  end
end
