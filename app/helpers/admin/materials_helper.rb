module Admin::MaterialsHelper
  def self.included(base)
    ActionView::Base.regions.append(:admin_menu, :material_admin_menu_links)
    ActionView::Base.regions.append(:admin_index_blocks, :material_admin_block)
  end

  def material_admin_menu_links
    (Material.types - [Material]).collect do |type|
      admin_menu_item(
        link_to(
          ""["materials_types_#{type.to_s.tableize}".to_sym] + (type.pending.count > 0 ? " (+#{type.pending.count})" : ""),
          [:admin, type.new]
        ),
        (params[:controller] == "admin/materials" and params[:material_type] == type.to_s)
      )
    end
  end

  def material_admin_block
    render :partial => "admin/index/material_block"
  end

  def material_controls(material, options = {})
    render(:partial => "admin/materials/controls", :locals => {:material => material}.merge(options))
  end
end
