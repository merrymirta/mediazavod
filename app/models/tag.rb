class Tag < ActiveRecord::Base
  # Tag cloud for materials

  named_scope :material_filter, Proc.new {|parent|
    if parent.is_a?(Section)
      {:conditions => ["taggables.state = ? AND taggables.section_id = ?", "publicated", parent.id]}
    else
      {}
    end
  }

  def self.popular_for_materials(parent, type)
    self.material_filter(parent).popular(:taggable => type)
  end
end