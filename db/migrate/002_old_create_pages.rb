class OldCreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :user_id
      
      t.string  :permalink
      t.string  :name
      t.text    :content
      t.integer :content_filter,  :default => 0
      
      t.string  :meta_title
      t.string  :meta_description
      t.string  :meta_keywords

      t.boolean  :publicated
      t.datetime :publicated_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
