module Lamby
  class RackAlb < Lamby::Rack

    def alb?
      true
    end

    def multi_value?
      event.key? 'multiValueHeaders'
    end

    def response(handler)
      multiValueHeaders = handler.headers.transform_values { |v| Array.wrap(v) } if multi_value?
      statusDescription = "#{handler.status} #{::Rack::Utils::HTTP_STATUS_CODES[handler.status]}"
      { multiValueHeaders: multiValueHeaders,
        statusDescription: statusDescription }.compact
    end

    private

    def env_base
      { ::Rack::REQUEST_METHOD => event['httpMethod'],
        ::Rack::SCRIPT_NAME => '',
        ::Rack::PATH_INFO => event['path'] || '',
        ::Rack::QUERY_STRING => query_string,
        ::Rack::SERVER_NAME => headers['host'],
        ::Rack::SERVER_PORT => headers['x-forwarded-port'],
        ::Rack::SERVER_PROTOCOL => 'HTTP/1.1',
        ::Rack::RACK_VERSION => ::Rack::VERSION,
        ::Rack::RACK_URL_SCHEME => headers['x-forwarded-proto'],
        ::Rack::RACK_INPUT => StringIO.new(body || ''),
        ::Rack::RACK_ERRORS => $stderr,
        ::Rack::RACK_MULTITHREAD => false,
        ::Rack::RACK_MULTIPROCESS => false,
        ::Rack::RACK_RUNONCE => false,
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
      (event['multiValueHeaders'] || {}).transform_values do |v|
        v.is_a?(Array) ? v.first : v
      end
    end

    def query_string
      @query_string ||= multi_value? ? query_string_multi : super
    end

    def query_string_multi
      query = event['multiValueQueryStringParameters'] || {}
      string = query.map do |key, value|
        value.map{ |v| "#{key}=#{v}" }.join('&')
      end.flatten.join('&')
    end

  end
end
