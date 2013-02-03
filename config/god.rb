SERVICE = "publishing"
USER    = "site"
GROUP   = "site"

RAILS_ROOT = File.dirname(File.dirname(__FILE__))

Dir[File.join(RAILS_ROOT, "vendor", "plugins", "*", "config", "god.rb")].each do |config|
  require config
end