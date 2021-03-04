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
        body: body }.merge(rack_response)
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
        @body.each { |part| rbody << part }
      end
    end

    def call
      return self if @called
      @status, @headers, @body = call_app
      set_cookies
      @called = true
      self
    end

    def base64_encodeable?
      @headers && (
        @headers['Content-Transfer-Encoding'] == 'binary' ||
        content_encoding_compressed? ||
        @headers['X-Lamby-Base64'] == '1'
      )
    end

    def body64
      Base64.strict_encode64(body)
    end

    private

    def rack
      @rack ||= case @options[:rack]
      when :rest, :api
        Lamby::RackRest.new @event, @context
      when :alb
        Lamby::RackAlb.new @event, @context
      else
        Lamby::RackHttp.new @event, @context
      end
    end

    def rack_response
      rack.response(self)
    end

    def call_app
      if Debug.on?(@event)
        Debug.call @event, @context, rack.env
      else
        @app.call rack.env
      end
    end

    def content_encoding_compressed?
      content_encoding_header = @headers['Content-Encoding'] || ''
      content_encoding_header.split(', ').any? { |h| ['br', 'gzip'].include?(h) }
    end
  end
end
