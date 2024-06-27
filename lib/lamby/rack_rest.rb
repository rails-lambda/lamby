module Lamby
  class RackRest < Lamby::Rack
    
    class << self

      def handle?(event)
        event.key?('httpMethod')
      end

    end

    def response(handler)
      if handler.base64_encodeable?
        { isBase64Encoded: true, body: handler.body64 }
      else
        super
      end.tap do |r|
        if cookies = handler.set_cookies
          r[:multiValueHeaders] ||= {}
          r[:multiValueHeaders]['Set-Cookie'] = cookies
        end
      end
    end

    private

    def env_base
      rack_version = defined?(::Rack::VERSION) ? ::Rack::VERSION : ::Rack::RELEASE
      { ::Rack::REQUEST_METHOD => event['httpMethod'],
        ::Rack::SCRIPT_NAME => '',
        ::Rack::PATH_INFO => event['path'] || '',
        ::Rack::QUERY_STRING => query_string,
        ::Rack::SERVER_NAME => headers['Host'],
        ::Rack::SERVER_PORT => headers['X-Forwarded-Port'],
        ::Rack::SERVER_PROTOCOL => event.dig('requestContext', 'protocol') || 'HTTP/1.1',
        ::Rack::RACK_VERSION => rack_version,
        ::Rack::RACK_URL_SCHEME => 'https',
        ::Rack::RACK_INPUT => StringIO.new(body || ''),
        ::Rack::RACK_ERRORS => $stderr,
        LAMBDA_EVENT => event,
        LAMBDA_CONTEXT => context
      }.tap do |env|
        ct = content_type
        cl = content_length
        env['CONTENT_TYPE'] = ct if ct
        env['CONTENT_LENGTH'] = cl if cl
      end
    end

  end
end
