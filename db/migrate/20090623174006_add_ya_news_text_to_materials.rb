class AddYaNewsTextToMaterials < ActiveRecord::Migration
  def self.up
    add_column :materials, :ya_news_text, :text
  end

  def self.down
    remove_column :materials, :ya_news_text
  end
end
