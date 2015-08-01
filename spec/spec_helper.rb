require 'rubygems'
require 'vcr'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/its'

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'
  config.include Rails.application.routes.url_helpers
end

VCR.configure do |c|
  c.cassette_library_dir = "#{::Rails.root}/spec/fixtures/cassettes"
  c.hook_into :webmock
end
