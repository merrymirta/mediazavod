class AddIndexesToContentTables < ActiveRecord::Migration
  def self.up
    add_index :articles, :author_id
    add_index :articles, :section_id
    add_index :articles, :state
    
    add_index :article_contents, :article_id
    
    add_index :galleries, :section_id
    add_index :galleries, :state
    
    add_index :shorties, :section_id
    add_index :shorties, :state
  end

  def self.down
    remove_index :articles, :author_id
    remove_index :articles, :section_id
    remove_index :articles, :state
    
    remove_index :article_contents, :article_id
    
    remove_index :galleries, :section_id
    remove_index :galleries, :state
    
    remove_index :shorties, :section_id
    remove_index :shorties, :state
  end
end
