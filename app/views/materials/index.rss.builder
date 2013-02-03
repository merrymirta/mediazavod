xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version => "2.0") do
  xml.channel do
    xml.language    'ru-RU'
    xml.title       parents.any? ? material_translate(@type, :index_header_with_parent, parents.last.name) : material_translate(@type, :index_header_without_parent)
    xml.link        url_for(params.merge(:only_path => false))
    xml.description material_translate(@type, :index_feed_description)
    
    @materials.each do |material|
      xml.item do
        xml.title       material.name

        xml.description do
          xml.cdata!( material_preview(material) )
        end
        
        xml.pubDate     material.publicated_at.to_s(:rfc822)
        xml.link        polymorphic_url(material)
        xml.guid        polymorphic_url(material)
      end
    end
  end
end