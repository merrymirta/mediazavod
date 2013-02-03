class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.integer :section_id
      t.integer :author_id

      t.string  :name
      t.text    :excerpt

      t.string  :source_name
      t.string  :source_url

      t.string  :state, :default => "draft"

      t.boolean :publicate_as_hot,            :default => false
      t.boolean :publicate_at_homepage,       :default => true
      t.boolean :publicate_at_section,        :default => true
      t.boolean :publicate_in_general_digest, :default => true
      t.boolean :publicate_in_section_digest, :default => true
      t.boolean :publicate_in_general_list,   :default => true
      t.boolean :publicate_in_section_list,   :default => true
      t.boolean :allow_comments,              :default => true
      t.boolean :allow_rating,                :default => true

      t.datetime  :publicated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
