module Lamby
  class RackAlb < Lamby::Rack

    class << self

      def handle?(event)
        event.key?('httpMethod') && 
          event.dig('requestContext', 'elb')
      end

    end

    def alb?
      true
    end

    def multi_value?
      event.key? 'multiValueHeaders'
    end

    def response(handler)
      hhdrs = handler.headers
      if multi_value?
        multivalue_headers = hhdrs.transform_values { |v| Array[v].compact.flatten }
        multivalue_headers['Set-Cookie'] = handler.set_cookies if handler.set_cookies
      end
      status_description = "#{handler.status} #{::Rack::Utils::HTTP_STATUS_CODES[handler.status]}"
      base64_encode = handler.base64_encodeable?(hhdrs)
      body = Base64.strict_encode64(handler.body) if base64_encode
      { multiValueHeaders: multivalue_headers,
        statusDescription: status_description,
        isBase64Encoded: base64_encode,
        body: body }.compact
    end

    private

    def env_base
      rack_version = defined?(::Rack::VERSION) ? ::Rack::VERSION : ::Rack.release
      { ::Rack::REQUEST_METHOD => event['httpMethod'],
        ::Rack::SCRIPT_NAME => '',
        ::Rack::PATH_INFO => event['path'] || '',
        ::Rack::QUERY_STRING => query_string,
        ::Rack::SERVER_NAME => headers['host'],
        ::Rack::SERVER_PORT => headers['x-forwarded-port'],
        ::Rack::SERVER_PROTOCOL => 'HTTP/1.1',
        ::Rack::RACK_VERSION => rack_version,
        ::Rack::RACK_URL_SCHEME => headers['x-forwarded-proto'],
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

    def headers
      @headers ||= multi_value? ? headers_multi : super
    end

    def headers_multi
      Hash[(event['multiValueHeaders'] || {}).map do |k,v|
        if v.is_a?(Array)
          if k == 'x-forwarded-for'
            [k, v.join(', ')]
          else
            [k, v.first]
          end
        else
          [k,v]
        end
      end]
    end

  end
end
