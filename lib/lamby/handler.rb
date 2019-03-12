module Lamby
  class Handler

    class << self

      def call(app, event, context)
        new(app, event, context).call.response
      end

    end

    def initialize(app, event, context)
      @app = app
      @event = event
      @context = context
      @rack = Lamby::Rack.new event, context
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

    def call_app
      if Debug.on?(@event)
        Debug.call @event, @context, @rack.env
      else
        @app.call @rack.env
      end
    end

  end
end
