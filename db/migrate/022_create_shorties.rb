class CreateShorties < ActiveRecord::Migration
  def self.up
    create_table :shorties do |t|
      t.integer :section_id
      
      t.string  :name
      t.text    :text
      
      t.integer :filter, :default => 0      
      
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

      t.integer :comments_count, :default => 0      
      
      t.timestamps
    end
  end

  def self.down
    drop_table :shorties
  end
end
