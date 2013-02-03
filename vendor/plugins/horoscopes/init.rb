require_plugin "commons"

Rails.configuration.gem "taf2-curb", :lib => "curb"

require File.join(File.dirname(__FILE__), "config", "routes")

Gibberish.language_paths.unshift(File.dirname(__FILE__))

Rails.configuration.idfix.helpers << :horoscopes