class Gallery < Material
  has_pictures

  protected

  # Adds picture names to search index. See Material#custom_search_index_options for details
  def self.custom_search_index_options(index)
    index.instance_eval do
      indexes pictures(:name), :as => :pictures
    end
  end
end
