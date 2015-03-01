require File.expand_path('../boot', __FILE__)

require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SecondWind
  class Application < Rails::Application
    config.autoload_paths += %W(#{config.root}/app/models/activities)
    config.active_record.raise_in_transactional_callbacks = true
  end
end