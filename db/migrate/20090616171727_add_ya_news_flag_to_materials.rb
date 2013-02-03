class AddYaNewsFlagToMaterials < ActiveRecord::Migration
  def self.up
    add_column :materials, :publicate_in_ya_news, :boolean
  end

  def self.down
    remove_column :materials, :publicate_in_ya_news
  end
end
