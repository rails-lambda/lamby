module Lamby
  class Rack
    LAMBDA_EVENT = 'lambda.event'.freeze
    LAMBDA_CONTEXT = 'lambda.context'.freeze
    HTTP_X_REQUESTID = 'HTTP_X_REQUEST_ID'.freeze
    HTTP_X_REQUEST_START = 'HTTP_X_REQUEST_START'.freeze
    HTTP_COOKIE = 'HTTP_COOKIE'.freeze
    
    class << self

      def lookup(type, event)
        types[type] || types.values.detect { |t| t.handle?(event) }
      end

      # Order is important. REST is hardest to isolated with handle? method.
      def types
        { alb:  RackAlb,
          http: RackHttp,
          rest: RackRest,
          api:  RackRest }
      end

    end

    attr_reader :event, :context

    def initialize(event, context)
      @event = event
      @context = context
    end

    def env
      @env ||= env_base.merge!(env_headers)
    end

    def response(_handler)
      {}
    end

    def multi_value?
      false
    end

    private

    def env_base
      raise NotImplementedError
    end

    def env_headers
      headers.transform_keys do |key|
        "HTTP_#{key.to_s.upcase.tr '-', '_'}"
      end.tap do |hdrs|
        hdrs[HTTP_X_REQUESTID] = request_id
        hdrs[HTTP_X_REQUEST_START] = "t=#{request_start}" if request_start
      end
    end

    def content_type
      headers.delete('Content-Type') || headers.delete('content-type') || headers.delete('CONTENT_TYPE')
    end

    def content_length
      bytesize = body.bytesize.to_s if body
      headers.delete('Content-Length') || headers.delete('content-length') || headers.delete('CONTENT_LENGTH') || bytesize
    end

    def body
      @body ||= if event['body'] && base64_encoded?
        Base64.decode64 event['body']
      else
        event['body']
      end
    end

    def headers
      @headers ||= event['headers'] || {}
    end

    def query_string
      @query_string ||= if event.key?('rawQueryString')
        event['rawQueryString']
      elsif event.key?('multiValueQueryStringParameters')
        query = event['multiValueQueryStringParameters'] || {}
        query.map do |key, value|
          value.map{ |v| "#{key}=#{v}" }.join('&')
        end.flatten.join('&')
      else
        build_query_string
      end
    end

    def build_query_string
      return if event['queryStringParameters'].nil?
      ::Rack::Utils.build_nested_query(
        event.fetch('queryStringParameters')
      ).gsub('[', '%5B')
       .gsub(']', '%5D')
    end

    def base64_encoded?
      event['isBase64Encoded']
    end

    def request_id
      context.aws_request_id
    end

    def request_start
      event.dig('requestContext', 'timeEpoch') || 
        event.dig('requestContext', 'requestTimeEpoch')
    end

  end
end
