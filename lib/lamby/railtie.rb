module Lamby
  class Railtie < ::Rails::Railtie
    config.lamby = Lamby::Config.config
  end
end
