class CreateGalleries < ActiveRecord::Migration
  def self.up
    create_table :galleries do |t|
      t.integer :section_id
      
      t.string  :name
      
      t.string  :state, :default => "draft"
      
      t.boolean :publicate_at_homepage, :default => true
      t.boolean :publicate_at_section,  :default => true
      t.boolean :allow_comments,        :default => true
      t.boolean :allow_rating,          :default => true
      
      t.datetime :publicated_at
      
      t.timestamps
    end
    
    add_column :pictures, :user_id, :integer
    add_column :pictures, :state, :string, :default => "recommended"
  end

  def self.down
    drop_table :galleries
    
    remove_column :pictures, :user_id
    remove_column :pictures, :state
  end
end
