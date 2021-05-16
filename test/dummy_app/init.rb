ENV['RAILS_ENV'] ||= 'test'
ENV["RAILS_SERVE_STATIC_FILES"] = '1'
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../Gemfile', __FILE__)
require 'bundler/setup'
require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'
Bundler.require(:default, Rails.env)

module Dummy
  class Application < ::Rails::Application

    # Basic Engine
    config.root = File.join __FILE__, '..'
    config.cache_store = :memory_store
    config.assets.enabled = false
    config.secret_key_base = '012345678901234567890123456789'
    config.active_support.test_order = :random
    config.logger = Logger.new('/dev/null')
    config.public_file_server.enabled = true
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=2592000",
      'X-Lamby-Base64' => '1'
    }
    # Mimic production environment.
    config.consider_all_requests_local = false
    config.action_dispatch.show_exceptions = true
    # Mimic test environment.
    config.action_controller.perform_caching = false
    config.action_controller.allow_forgery_protection = false
    config.action_mailer.delivery_method = :test
    config.active_support.deprecation = :stderr
    config.allow_concurrency = true
    config.cache_classes = true
    config.dependency_loading = true
    config.preload_frameworks = true
    config.eager_load = true
    config.middleware.insert_after ActionDispatch::Static, Rack::Deflater, sync: false if ENV['LAMBY_RACK_DEFLATE_ENABLED']
  end
end

Dummy::Application.initialize!
