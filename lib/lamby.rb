require 'lamby/logger'
require 'rack'
require 'base64'
require 'lamby/version'
require 'lamby/config'
require 'lamby/sam_helpers'
require 'lamby/rack'
require 'lamby/rack_alb'
require 'lamby/rack_rest'
require 'lamby/rack_http'
require 'lamby/debug'
require 'lamby/handler'

if defined?(Rails)
  require 'rails/railtie'
  require 'lamby/railtie'
end

module Lamby

  extend self

  def handler(app, event, context, options = {})
    Handler.call(app, event, context, options)
  end

  def config
    Lamby::Config.config
  end

  autoload :SsmParameterStore, 'lamby/ssm_parameter_store'

end
