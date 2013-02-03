class AddSectionsModule < ActiveRecord::Migration
  def self.up
    add_column :sections, :parent_id, :integer
    add_column :sections, :lft,       :integer
    add_column :sections, :rgt,       :integer

    remove_column :sections, :position

    Section.transaction do
      Section.find(:all).each_with_index do |section, index|
        rgt = (index + 1) * 2
        lft = rgt - 1

        ActiveRecord::Base.connection.execute(
          "UPDATE sections SET lft = #{lft}, rgt = #{rgt} WHERE id = #{section.id}"
        )
      end
    end
    
    ActiveRecord::Base.connection.execute("INSERT INTO plugin_schema_info(plugin_name, version) VALUES('sections', 1)")
  end

  def self.down
    add_column :sections, :position, :integer

    remove_column :sections, :parent_id, :lft, :rgt
    
    ActiveRecord::Base.connection.execute("DELETE FROM plugin_schema_info WHERE plugin_name = 'sections' AND version = 1")
  end
end
