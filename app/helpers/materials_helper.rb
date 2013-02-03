module MaterialsHelper
  def material_translate(type, key, *args)
    text = ""[*args.dup.unshift("#{type.to_s.tableize}_#{key}".to_sym)]
    text = ""[*args.dup.unshift("materials_#{key}".to_sym)] if text.blank?

    return text
  end

  def material_preview(material, options = {})
    options = options.dup

    # Receiving material options from custom method if it is defined
    options.reverse_merge!(
      self.send(material.class.to_s.underscore + "_preview_options", material, options)
    ) if self.respond_to?(material.class.to_s.underscore + "_preview_options")

    # Merging commonly used options
    options.reverse_merge!(
      :class              => :preview,
      :thumbnail_format   => material_translate(material.class, :preview_picture_format),
      :excerpt            => true,
      :meta               => {},
      :controls           => true
    )

    begin
      render(
        :partial  => "#{material.class.to_s.tableize}/#{material.class.to_s.underscore}",
        :locals   => { :material => material, :options => options }
      )
    rescue ActionView::MissingTemplate
      render(
        :partial  => "materials/material",
        :locals   => { :material => material, :options => options }
      )
    end
  end
  
  def material_meta(material, options = {})
    options = options.dup

    options.reverse_merge!(
      :class      => :metadata,
      :section    => true,
      :comments   => true,
      :rating     => true,
      :tag_list   => true,
      :date       => true
    )
    
    begin
      render(
        :partial  => "#{material.class.to_s.tableize}/meta",
        :locals   => { :material => material, :options => options }
      )
    rescue ActionView::MissingTemplate
      render(
        :partial  => "materials/meta",
        :locals   => { :material => material, :options => options }
      )
    end
  end
  
  Material.types.each do |type|
    alias_method type.to_s.underscore + "_preview", :material_preview
    alias_method type.to_s.underscore + "_meta", :material_meta
  end

  def related_materials_for(material, options = {})
    begin
      render(
        :partial  => "#{material.class.to_s.tableize}/related",
        :locals   => { :source => material, :options => options }
      )
    rescue ActionView::MissingTemplate
      render(
        :partial  => "materials/related",
        :locals   => { :source => material, :options => options }
      )
    end
  end

  def material_tag_cloud(container, type)
    begin
      render(
        :partial  => "#{type.to_s.tableize}/tag_cloud",
        :locals   => { :container => container, :type => type }
      )
    rescue ActionView::MissingTemplate
      render(
        :partial  => "materials/tag_cloud",
        :locals   => { :container => container, :type => type }
      )
    end
  end
end
