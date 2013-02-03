class CreateUserArticles < ActiveRecord::Migration
  def self.up
    create_table :user_articles do |t|
      t.integer :author_id

      t.string  :title
      t.text    :content

      t.string  :state, :limit => 30
      
      t.timestamps
    end
  end

  def self.down
    drop_table :user_articles
  end
end
