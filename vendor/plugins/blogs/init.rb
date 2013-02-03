require_plugin "commons"
require_plugin "comments"

require File.join(File.dirname(__FILE__), "config", "routes")

Gibberish.language_paths.unshift(File.dirname(__FILE__))

Rails.configuration.idfix.helpers << :blog_posts << "admin/blog_posts"