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
    end

    def response
      @response
    end

    def status
      @status
    end

    def headers
      @headers
    end

    def set_cookies
      return @set_cookies if defined?(@set_cookies)
      @set_cookies = if @headers && @headers['Set-Cookie']
        @headers.delete('Set-Cookie').split("\n")
      end
    end

    def body
      @rbody ||= ''.tap do |rbody|
        @body.each { |part| rbody << part if part }
        @body.close if @body.respond_to? :close
      end
    end

    def call
      @response ||= call_app
      self
    end

    def base64_encodeable?(hdrs = @headers)
      hdrs && (
        hdrs['Content-Transfer-Encoding'] == 'binary' ||
        content_encoding_compressed?(hdrs) ||
        hdrs['X-Lamby-Base64'] == '1'
      )
    end

    def body64
      Base64.strict_encode64(body)
    end

    private

    def rack
      return @rack if defined?(@rack)
      @rack = begin
        type = rack_option
        klass = Lamby::Rack.lookup type, @event
        (klass && klass.handle?(@event)) ? klass.new(@event, @context) : false
      end
    end

    def rack_option
      return if ENV['LAMBY_TEST_DYNAMIC_HANDLER']
      @options[:rack]
    end

    def rack_response
      { statusCode: status,
        headers: headers,
        body: body }.merge(rack.response(self))
    end

    def call_app
      if Debug.on?(@event)
        Debug.call @event, @context, rack.env
      elsif rack?
        @status, @headers, @body = @app.call rack.env 
        set_cookies
        rack_response
      elsif runner?
        @status, @headers, @body = Runner.call(@event)
        { statusCode: status, headers: headers, body: body }
      elsif lambdakiq?
        Lambdakiq.handler(@event)
      elsif event_bridge?
        Lamby.config.event_bridge_handler.call @event, @context
      else
        [404, {}, StringIO.new('')]
      end
    end

    def content_encoding_compressed?(hdrs)
      content_encoding_header = hdrs['Content-Encoding'] || ''
      content_encoding_header.split(', ').any? { |h| ['br', 'gzip'].include?(h) }
    end

    def rack?
      rack
    end

    def event_bridge?
      Lamby.config.event_bridge_handler &&
        @event.key?('source') && @event.key?('detail') && @event.key?('detail-type')
    end

    def lambdakiq?
      defined?(::Lambdakiq) && ::Lambdakiq.jobs?(@event)
    end

    def runner?
      Runner.handle?(@event)
    end
  end
end
