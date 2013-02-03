class AddAuthorToGalleries < ActiveRecord::Migration
  def self.up
    add_column :galleries, :author_id, :integer
  end

  def self.down
    remove_column :galleries, :author_id
  end
end
