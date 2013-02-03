class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :parent_id
      t.integer :root_id
      t.integer :lft
      t.integer :rgt
      
      t.integer :commentable_id
      t.string  :commentable_type
      
      t.integer :user_id
      
      t.string  :user_name
      t.string  :user_email
      t.string  :user_site
      
      t.text    :text
      
      t.string  :state, :default => "pending"
      
      t.timestamps
    end
    
    add_column :articles, :comments_count, :integer, :default => 0
    add_column :galleries, :comments_count, :integer, :default => 0
  end

  def self.down
    drop_table :comments

    remove_column :articles, :comments_count
    remove_column :galleries, :comments_count
  end
end
