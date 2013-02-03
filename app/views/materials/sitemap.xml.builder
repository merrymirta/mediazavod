xml.instruct! :xml, :version => "1.0"
xml.urlset(:xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9') do
  @materials.each do |material|
    xml.url do
      xml.log polymorphic_url(material)
      xml.lastmod material.updated_at.to_date.to_s
      xml.changefreq 'weekly'
      xml.priority 0.5
    end
  end
end