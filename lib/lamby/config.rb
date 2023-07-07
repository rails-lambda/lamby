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

    def rack_app
      @rack_app ||= ::Rack::Builder.new { run ::Rails.application }.to_app
    end

    def rack_app=(app)
      @rack_app = app
    end

    def initialize_defaults
      @rack_app = nil
      @cold_start_metrics = false
      @metrics_app_name = nil
      @event_bridge_handler = lambda { |event, context| puts(event) }
    end

    def event_bridge_handler
      @event_bridge_handler
    end

    def event_bridge_handler=(func)
      @event_bridge_handler = func
    end

    def runner_patterns
      LambdaConsole::Run::PATTERNS
    end

    def handled_proc
      @handled_proc ||= Proc.new { |_event, _context| }
    end

    def handled_proc=(proc)
      @handled_proc = proc
    end

    def cold_start_metrics?
      @cold_start_metrics
    end

    def cold_start_metrics=(bool)
      @cold_start_metrics = bool
    end

    def metrics_app_name
      @metrics_app_name
    end

    def metrics_app_name=(name)
      @metrics_app_name = name
    end

  end
end
