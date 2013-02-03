class AddPositionToPictures < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      add_column :pictures, :position, :integer
      
#      if Page.count > 0
#        Page.find(:all, :include => :pictures).select{|page| page.pictures.count > 0}.each do |page|
#          position = 1
#
#          page.pictures.each do |picture|
#            picture.update_attribute(:position, position)
#            position += 1
#          end
#        end
#      end
    end
  end

  def self.down
    remove_column :pictures, :position
  end
end
