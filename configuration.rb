require 'bundler'
Bundler.setup

require 'compass'
require 'coderay'
require 'haml-coderay'

# Parse the Compass config
Compass.add_project_configuration('config.rb')

# Default is 3000
configuration.preview_server_port = 3000

# Default is localhost
configuration.preview_server_host = "localhost"

# Default is true
# When false .html & index.html get stripped off generated urls
configuration.use_extensions_for_page_links = true

# Default is an empty hash
# We use Compass's config
configuration.sass_options = Compass.sass_engine_options

# Default is an empty hash
# http://haml-lang.com/docs/yardoc/file.HAML_REFERENCE.html#options
configuration.haml_options = {
  #:format => :html5,
  :attr_wrapper => '"'
}

$:.unshift File.dirname(__FILE__) + "/lib"
require 'staticmatic/mess'

StaticMatic::Base.class_eval do
  include StaticMatic::MetadataMethods
  include StaticMatic::Hooks
  include StaticMatic::PageMethods
  include StaticMatic::FeedMethods
        
  before_build do |me|
    me.setup_pages!
  end
  
  after_build do |staticmatic|
    staticmatic.write_feed
  end
end

Haml::Helpers.class_eval("include PageHelper")### FIXME: fix staticmatic.
