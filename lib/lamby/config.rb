module Lamby
  module Config

    def configure
      yield(config)
      config
    end

    def reconfigure
      config.reconfigure { |c| yield(c) if block_given? }
    end

    def config
      @config ||= Configuration.new
    end

    extend self

  end

  class Configuration

    def initialize
      initialize_defaults
    end

    def reconfigure
      instance_variables.each { |var| instance_variable_set var, nil }
      initialize_defaults
      yield(self) if block_given?
      self
    end

    def initialize_defaults
      @event_bridge_handler = lambda { |event, context| puts(event) }
    end

    def event_bridge_handler
      @event_bridge_handler
    end

    def event_bridge_handler=(func)
      @event_bridge_handler = func
    end

    def runner_patterns
      Runner::PATTERNS
    end

  end
end
