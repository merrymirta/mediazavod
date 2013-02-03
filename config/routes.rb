# Функции для создания однотипных вложенных ресурсов для разных объектов
# TODO: переписать в формате методов класса для генератора роутов

ActionController::Routing::Routes.draw do |map|
  map.root :controller => "pages", :action => "home"
  

  map.resources :newspapers

  map.connect "/newspapers/:id/by_date/:date",
    :controller => "newspapers",
    :action     => "show"

  map.admin do |admin|
    Material.types.each do |type|
      admin.resources(type.to_s.tableize,
        :controller   => "materials",
        :requirements => {:material_type => type.to_s},
        :collection   => { :upload_archive => :any },
        :member       => { :send_to_test => :post, :publicate => :any }
      ) do |m|
        m.has_pictures
        m.has_assets
      end
    end

    admin.resources :user_articles,
      :member => {
        :approve => :post,
        :decline => :post,
        :feature => :post
      }
  end

  # Articles, galleries with pagination
  
  Material.types.each do |type|
    map.with_options(
      :controller => "materials",
      :action => "index",
      :page => 1,
      :requirements => {:material_type => type.to_s}
    ) do |object|
      resource = type.to_s.tableize

      object.connect "/#{resource}.:format", :page => nil
      object.connect "/#{resource}/index/:page"
      object.connect "/#{resource}/by_date/:date/:page"

      object.connect "/sections/:section_id/#{resource}.:format", :page => nil
      object.connect "/sections/:section_id/#{resource}/index/:page"
      object.connect "/sections/:section_id/#{resource}/by_date/:date/:page"

      object.connect "/tags/:tag_id/#{resource}.:format", :page => nil
      object.connect "/tags/:tag_id/#{resource}/index/:page"
      object.connect "/tags/:tag_id/#{resource}/by_date/:date/:page"
    end
  end

  map.has_sections do |section|
    Material.types.each do |type|
      section.resources type.to_s.tableize,
        :controller   => "materials",
        :requirements => {:material_type => type.to_s}
    end
  end
  
  map.has_tags do |tag|
    Material.types.each do |type|
      tag.resources type.to_s.tableize,
        :controller   => "materials",
        :requirements => {:material_type => type.to_s}
    end
  end

  Material.types.each do |type|
    map.resources(
      type.to_s.tableize,
      :collection   => { :homepage => :any, :informer => :any, :yanews => :any, :sitemap => :any },
      :controller   => "materials",
      :requirements => {:material_type => type.to_s}
    ) do |material|

      material.has_comments
      material.has_pictures
      material.has_rates
    end
  end

  map.resources :user_articles do |article|
    article.has_pictures
    article.has_comments
  end

  map.resources :users, :has_many => :comments do |user|
    user.has_blog
  end

  map.passport_routes 
  map.search_routes
  map.weather_routes
  map.currency_routes
  map.settings_routes
  map.horoscopes_routes
  map.blog_routes

  map.common_routes

  map.static_page_routes
end