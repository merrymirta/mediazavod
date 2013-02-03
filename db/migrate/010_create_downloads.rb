class CreateDownloads < ActiveRecord::Migration
  def self.up
    create_table :downloads do |t|
      t.integer :page_id
      t.string  :name
      t.integer :size
      t.string  :content_type
      t.string  :filename
      
      t.timestamps 
    end
  end

  def self.down
    drop_table :downloads
  end
end
