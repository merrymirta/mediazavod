class CreateBlogPosts < ActiveRecord::Migration
  def self.up
    create_table :blog_posts do |t|
      t.integer :author_id

      t.string  :title
      t.text    :excerpt
      t.text    :content

      t.string  :state

      t.timestamps
    end
  end

  def self.down
    drop_table :blog_posts
  end
end