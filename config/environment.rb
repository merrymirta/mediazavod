# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.1' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

require File.join(RAILS_ROOT, "vendor", "plugins", "commons", "lib", "configuration")

Rails::Initializer.run(:process, Rails::IdfixConfiguration.new(:mediazavod, :publishing)) do |config|
  config.time_zone = 'Ekaterinburg'

  config.idfix.metadata[:title]       = "Медиа Завод"
  config.idfix.metadata[:description] = "Сайт информационного портала Медиа Завод"
  config.idfix.metadata[:keywords]    = "Сайт информационного портала Медиа Завод"

  config.idfix.banners = { :site_id => 1 }

  config.idfix.weather = { :town_id => 4565 }

  config.idfix.parser_folder = File.join(RAILS_ROOT, "parser")

  config.gem "builder"
end

require "RedCloth-3.0.4/lib/redcloth" unless Object.const_defined?(:RedCloth)
require "BlueCloth-1.0.0/lib/bluecloth" unless Object.const_defined?(:BlueCloth)
require "xml_utf8_fix"

Material.types.each do |type|
  # Setting up search indexes for materials
  type.setup_search_index
end

Rails.configuration.idfix.widgets << :section