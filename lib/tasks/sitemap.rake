namespace :app do
  namespace :sitemap do
    desc "Generate sitemap"
    task :generate => :environment do
      File.open(File.join(RAILS_ROOT, 'public/sitemap.xml'), 'w+') do |f|
        xml = Builder::XmlMarkup.new(:target => f)
      
        xml.instruct!(:xml, :version => "1.0")
      
        xml.sitemapindex(:xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9") do
          (1 .. (Article.publicated.count.to_f / 10_000).ceil).each do |page|
            puts "Articles page #{page}..."
          
            system("wget -O #{RAILS_ROOT}/public/sitemap_articles_#{page}.xml http://mediazavod.ru/articles/sitemap.xml?page=#{page}")
        
            xml.sitemap do
              xml.loc "http://mediazavod.ru/sitemap_articles_#{page}.xml"
              xml.lastmod Time.now
            end
          end
        
          (1 .. (Shorty.publicated.count.to_f / 10_000).ceil).each do |page|
            puts "Shorties page #{page}..."

            system("wget -O #{RAILS_ROOT}/public/sitemap_shorties_#{page}.xml http://mediazavod.ru/shorties/sitemap.xml?page=#{page}")
        
            xml.sitemap do
              xml.loc "http://mediazavod.ru/sitemap_shorties_#{page}.xml"
              xml.lastmod Time.now
            end
          end

          (1 .. (Gallery.publicated.count.to_f / 10_000).ceil).each do |page|
            puts "Galleries page #{page}..."

            system("wget -O #{RAILS_ROOT}/public/sitemap_galleries_#{page}.xml http://mediazavod.ru/galleries/sitemap.xml?page=#{page}")
        
            xml.sitemap do
              xml.loc "http://mediazavod.ru/sitemap_shorties_#{page}.xml"
              xml.lastmod Time.now
            end
          end
        end
      end
      
      puts "Done!"
    end
  end
end