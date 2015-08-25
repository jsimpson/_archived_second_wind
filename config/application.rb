require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'broutes'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SecondWind
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/app/models/activities)
    config.active_record.raise_in_transactional_callbacks = true
    config.time_zone = 'Pacific Time (US & Canada)'
    config.middleware.use Rack::Deflater
  end
end
