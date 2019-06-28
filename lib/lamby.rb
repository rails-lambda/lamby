require 'lamby/logger'
require 'rack'
require 'base64'
require 'active_support/all'
require 'lamby/version'
require 'lamby/sam_helpers'
require 'lamby/rack_alb'
require 'lamby/rack_api'
require 'lamby/debug'
require 'lamby/handler'
require 'rails/railtie'
require 'lamby/railtie'

module Lamby

  extend self

  def handler(app, event, context, options = {})
    Handler.call(app, event, context, options)
  end

  autoload :SsmParameterStore, 'lamby/ssm_parameter_store'

end
