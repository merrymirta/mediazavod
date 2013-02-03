class MakePicturesPolymorphical < ActiveRecord::Migration
  def self.up
    rename_column :pictures, :page_id, :holder_id
    add_column :pictures, :holder_type, :string
    
    #Picture.update_all "holder_type = 'Page'"
  end

  def self.down
    rename_column :pictures, :holder_id, :page_id
    remove_column :pictures, :holder_type
  end
end
