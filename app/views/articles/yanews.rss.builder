xml.instruct! :xml, :version=>"1.0"
xml.rss(:version => "2.0", "xmlns:yandex" => "http://news.yandex.ru") do
  xml.channel do
    xml.title       "МедиаЗавод"
    xml.link        root_url
    xml.description material_translate(@type, :index_feed_description)
    xml.image do
      xml.url image_path("design/logo100x100.gif")
      xml.title "МедиаЗавод"
      xml.link root_url
    end

    @materials.each do |material|
      xml.item do
        xml.title       material.name
        xml.description strip_tags(
          filter_content(material.excerpt, material.filter)
        )

        xml.tag!("yandex:full-text",
          strip_tags(
            filter_content(material.ya_news_text, material.article_content.filter)
          )
        )

        xml.category(material.section.name)

        material.pictures.each do |picture|
          xml.enclosure :url => image_path(picture.image.url("600x600>")), :type => picture.image_content_type
        end

        xml.pubDate     material.publicated_at.to_s(:rfc822)
        xml.link        polymorphic_url(material)
        xml.pdalink     polymorphic_url(material)
      end
    end
  end
end