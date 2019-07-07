module Lamby
  class RackApi < Lamby::Rack

    def api?
      true
    end

    private

    def env_base
      { ::Rack::REQUEST_METHOD => event['httpMethod'],
        ::Rack::SCRIPT_NAME => '',
        ::Rack::PATH_INFO => event['path'] || '',
        ::Rack::QUERY_STRING => query_string,
        ::Rack::SERVER_NAME => headers['Host'],
        ::Rack::SERVER_PORT => headers['X-Forwarded-Port'],
        ::Rack::SERVER_PROTOCOL => event.dig('requestContext', 'protocol') || 'HTTP/1.1',
        ::Rack::RACK_VERSION => ::Rack::VERSION,
        ::Rack::RACK_URL_SCHEME => 'https',
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

  end
end
