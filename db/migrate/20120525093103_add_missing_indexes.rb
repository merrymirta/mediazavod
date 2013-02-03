class AddMissingIndexes < ActiveRecord::Migration
  def self.up
    add_index :blog_posts, :author_id
    add_index :user_articles, :author_id
    add_index :widgets, :widget_container_id
    add_index :comments, [:commentable_id, :commentable_type]
    add_index :rates, [:rateable_id, :rateable_type]
  end

  def self.down
    remove_index :blog_posts, :author_id
    remove_index :user_articles, :author_id
    remove_index :widgets, :widget_container_id
    remove_index :comments, [:commentable_id, :commentable_type]
    remove_index :rates, [:rateable_id, :rateable_type]
  end
end
