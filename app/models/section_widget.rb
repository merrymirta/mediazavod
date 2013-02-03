class SectionWidget < Widget
  def self.section_options_for_select
    Section.all.collect{|s|
      [s.name, s.id]
    }
  end

  def section_id
    settings[:section_id].to_i
  end

  def section_id=(value)
    settings[:section_id] = value
  end

  def section
    @section ||= Section.find_by_id(section_id)
  end


  def limit
    settings[:limit].to_i > 0 ? settings[:limit].to_i : 1
  end

  def limit=(value)
    settings[:limit] = value.to_i
  end


  def widget_name_as_title
    settings[:widget_name_as_title]
  end

  def widget_name_as_title=(value)
    settings[:widget_name_as_title] = (value.to_i == 1)
  end

  def title
    widget_name_as_title ? name : section.name
  end


  def featured_comments
    settings[:featured_comments]
  end

  def featured_comments=(value)
    settings[:featured_comments] = (value.to_i == 1)
  end


  def author_picture
    settings[:author_picture]
  end

  def author_picture=(value)
    settings[:author_picture] = (value.to_i == 1)
  end
end