module Lamby
  class Rack

    include SamHelpers

    LAMBDA_EVENT = 'lambda.event'.freeze
    LAMBDA_CONTEXT = 'lambda.context'.freeze
    HTTP_X_REQUESTID = 'HTTP_X_REQUEST_ID'.freeze

    attr_reader :event, :context

    def initialize(event, context)
      @event = event
      @context = context
    end

    def env
      @env ||= env_base.merge!(env_headers)
    end

    def response
      {}
    end

    def api?
      false
    end

    def alb?
      false
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
      @query_string ||= event['queryStringParameters'].try(:to_query)
    end

    def base64_encoded?
      event['isBase64Encoded']
    end

    def request_id
      context.aws_request_id
    end

  end
end
