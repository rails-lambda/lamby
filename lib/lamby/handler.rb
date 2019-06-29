module Lamby
  class Handler

    class << self

      def call(app, event, context, options = {})
        new(app, event, context, options).call.response
      end

    end

    def initialize(app, event, context, options = {})
      @app = app
      @event = event
      @context = context
      @options = options
      @called = false
    end

    def response
      { statusCode: status,
        headers: headers,
        body: body }
    end

    def status
      @status
    end

    def headers
      @headers
    end

    def body
      @rbody ||= ''.tap do |rbody|
        @body.each { |part| rbody << part }
      end
    end

    def call
      return self if @called
      @status, @headers, @body = call_app
      @called = true
      self
    end

    private

    def rack
      @rack ||= case @options[:rack]
      when :api
        Lamby::RackApi.new @event, @context
      else
        Lamby::RackAlb.new @event, @context
      end
    end

    def call_app
      if Debug.on?(@event)
        Debug.call @event, @context, rack.env
      else
        @app.call rack.env
      end
    end

  end
end
