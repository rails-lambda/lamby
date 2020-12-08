ENV['RAILS_SERVE_STATIC_FILES'] = '1'
require_relative 'config/boot'
require 'dotenv' ; Dotenv.load ".env.#{ENV['RAILS_ENV']}"
require 'lamby'
require_relative 'config/application'
require_relative 'config/environment'

$app = Rack::Builder.new { run Rails.application }.to_app

def handler(event:, context:)
  Lamby.handler $app, event, context, rack: :http
end
