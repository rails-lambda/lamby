module Lamby
  class RackHttp < Lamby::Rack

    def response(handler)
      if handler.base64_encodeable?
        { isBase64Encoded: true, body: handler.body64 }
      else
        super
      end.tap do |r|
        if cookies = handler.set_cookies
          if payload_version_one?
            r[:multiValueHeaders] ||= {}
            r[:multiValueHeaders]['Set-Cookie'] = cookies
          else
            r[:cookies] = cookies
          end
        end
      end
    end

    private

    def env_base
      { ::Rack::REQUEST_METHOD => request_method,
        ::Rack::SCRIPT_NAME => '',
        ::Rack::PATH_INFO => path_info,
        ::Rack::QUERY_STRING => query_string,
        ::Rack::SERVER_NAME => server_name,
        ::Rack::SERVER_PORT => server_port,
        ::Rack::SERVER_PROTOCOL => server_protocol,
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

    def env_headers
      super.tap do |hdrs|
        if cookies.any?
          hdrs[HTTP_COOKIE] = cookies.join('; ')
        end
      end
    end

    def request_method
      event.dig('requestContext', 'http', 'method') || event['httpMethod']
    end

    def cookies
      event['cookies'] || []
    end

    # Using custom domain names with v1.0 yields a good `path` parameter sans
    # stage. However, v2.0 and others do not. So we are just going to remove stage
    # no matter waht from other places for both.
    #
    def path_info
      stage = event.dig('requestContext', 'stage')
      spath = event.dig('requestContext', 'http', 'path') || event.dig('requestContext', 'path')
      spath.sub /\A\/#{stage}/, ''
    end

    def server_name
      headers['x-forwarded-host'] ||
        headers['X-Forwarded-Host'] ||
        headers['host'] ||
        headers['Host']
    end

    def server_port
      headers['x-forwarded-port'] || headers['X-Forwarded-Port']
    end

    def server_protocol
      event.dig('requestContext', 'http', 'protocol') ||
        event.dig('requestContext', 'protocol') ||
        'HTTP/1.1'
    end

    def payload_version_one?
      event['version'] == '1.0'
    end

  end
end
