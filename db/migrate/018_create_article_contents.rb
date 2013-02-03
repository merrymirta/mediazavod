class CreateArticleContents < ActiveRecord::Migration
  def self.up
    create_table :article_contents do |t|
      t.integer :article_id
      
      t.text    :text
      t.integer :filter, :default => 0
      
      t.timestamps
    end
  end

  def self.down
    drop_table :article_contents
  end
end
