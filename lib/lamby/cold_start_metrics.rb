module Lamby
  class ColdStartMetrics
    NAMESPACE = 'Lamby'

    @cold_start = true
    @cold_start_time = (Time.now.to_f * 1000).to_i

    class << self

      def instrument!
        return unless @cold_start
        @cold_start = false
        now = (Time.now.to_f * 1000).to_i
        proactive_init = (now - @cold_start_time) > 10_000
        new(proactive_init).instrument!
      end

      def clear!
        @cold_start = true
        @cold_start_time = (Time.now.to_f * 1000).to_i
      end

    end

    def initialize(proactive_init)
      @proactive_init = proactive_init
      @metrics = []
      @properties = {}
    end

    def instrument!
      name = @proactive_init ? 'ProactiveInit' : 'ColdStart'
      put_metric name, 1, 'Count'
      puts JSON.dump(message)
    end

    private

    def dimensions
      [{ AppName: rails_app_name }]
    end

    def put_metric(name, value, unit = nil)
      @metrics << { 'Name': name }.tap do |m|
        m['Unit'] = unit if unit
      end
      set_property name, value
    end

    def set_property(name, value)
      @properties[name] = value
      self
    end

    def message
      {
        '_aws': {
          'Timestamp': timestamp,
          'CloudWatchMetrics': [
            {
              'Namespace': NAMESPACE,
              'Dimensions': [dimensions.map(&:keys).flatten],
              'Metrics': @metrics
            }
          ]
        }
      }.tap do |m|
        dimensions.each { |d| m.merge!(d) }
        m.merge!(@properties)
      end
    end

    def timestamp
      Time.current.strftime('%s%3N').to_i
    end

    def rails_app_name
      Lamby.config.metrics_app_name ||
        Rails.application.class.name.split('::').first
    end

  end
end
