class RemoveDefaultFilterFromArticleContent < ActiveRecord::Migration
  def self.up
    change_column :article_contents, :filter, :integer, :default => nil
  end

  def self.down
    change_column :article_contents, :filter, :integer, :default => 0
  end
end
