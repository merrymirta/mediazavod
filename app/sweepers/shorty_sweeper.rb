class ShortySweeper < ActionController::Caching::Sweeper
  def after_create(shorty)
    expire_cache_for(shorty)
  end
  
  def after_update(shorty)
    expire_cache_for(shorty)
  end
  
  private
  
  def expire_cache_for(shorty)
    expire_by_path do |paths|
      paths << shorty_path(shorty)
      paths << shorties_path

      # Collecting section and all its parents
      shorty.section.self_and_ancestors.each do |section|
        paths << section_shorties_path(shorty.section)
      end
    end
    
    expire_page(section_path(shorty.section))
    expire_page(root_path)
  end
end