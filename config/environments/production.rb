# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
config.action_mailer.raise_delivery_errors = false
# FIXME: Эту опцию нужно отключить сразу после настройки отправки почты

config.idfix.domain = "http://mediazavod.ru"
config.idfix.domain_aliases = ["www.mediazavod.ru", "XN--80AAGFDBQG7A1A.XN--P1AI", "XN----8SBBCQTADFEEJ2AU1AL0HO3L.XN--P1AI", "XN--80ABLY2D7B.XN--P1AI"]