ENV['RAILS_ENV'] ||= 'test'
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../Gemfile', __FILE__)
require 'bundler/setup'
require 'rails/all'
Bundler.require(:default, Rails.env)

module Dummy
  class Application < ::Rails::Application

    # Basic Engine
    config.root = File.join __FILE__, '..'
    config.cache_store = :memory_store
    config.assets.enabled = false
    config.secret_key_base = '012345678901234567890123456789'
    config.active_support.test_order = :random

    # Mimic Test Environment Config.
    config.consider_all_requests_local = true
    config.action_controller.perform_caching = false
    config.action_dispatch.show_exceptions = false
    config.action_controller.allow_forgery_protection = false
    config.action_mailer.delivery_method = :test
    config.active_support.deprecation = :stderr
    config.allow_concurrency = true
    config.cache_classes = true
    config.dependency_loading = true
    config.preload_frameworks = true
    config.eager_load = true
    config.active_record.sqlite3.represent_boolean_as_integer = true

  end
end

Dummy::Application.initialize!






# require 'rails'
# require 'rails/all'
# require 'lamby'

# I18n.enforce_available_locales = true

# module Dummy
#   class Application < ::Rails::Application

#     config.root = File.join __FILE__, '..'
#     config.secret_key_base = '012345678901234567890123456789'
#     config.active_support.deprecation = :stderr
#     config.cache_store = :null_store
#     config.consider_all_requests_local = true
#     config.eager_load = false
#     config.active_support.test_order = :random
#     config.assets.compress = false
#     config.assets.cache_store = :file_store
#     config.assets.debug = true
#     config.assets.precompile += []
#     config.assets.digest = true
#     if ENV['RAILS_ENV'] == 'test'
#       config.cache_classes = true
#       config.eager_load = true
#       config.consider_all_requests_local       = true
#       config.action_controller.perform_caching = false
#     end

#   end
# end

# Dummy::Application.initialize!
