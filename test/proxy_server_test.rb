require 'net/http'
require 'test_helper'

class ProxyServerTest < LambySpec
  let(:event)    { TestHelpers::Events::HttpV2.create }
  let(:context)  { TestHelpers::LambdaContext.raw_data }
  let(:rack_app) { Rack::Builder.new { run lambda { |env| [200, {}, StringIO.new('{"statusCode": 200}')] } }.to_app }
  let(:proxy)    { Lamby::ProxyServer.new }

  before { Lamby.config.rack_app = rack_app }
  
  it 'should return a 405 helpful message on GET' do
    response = proxy.call(env("REQUEST_METHOD" => 'GET'))
    expect(response[:statusCode]).must_equal 405
    expect(response[:headers]).must_equal({"Content-Type" => "text/html"})
    expect(response[:body]).must_include 'Method Not Allowed'
  end
  
  it 'should call Lamby.cmd on POST' do
    response = proxy.call(env)
    expect(response[:statusCode]).must_equal 200
    expect(response[:headers]).must_equal({})
    expect(response[:body]).must_equal '{"statusCode": 200}'
  end

  private

  def env(options={})
    json = {"event": event, "context": context}.to_json
    { 'REQUEST_METHOD' => 'POST',
      'PATH_INFO' => '/',
      'QUERY_STRING' => '',
      'SERVER_NAME' => 'localhost',
      'SERVER_PORT' => '3000',
      'HTTP_VERSION' => 'HTTP/1.1',
      'rack.version' => Rack::VERSION,
      'rack.input' => StringIO.new(json),
      'rack.url_scheme' => 'http',
      'rack.errors' => $stderr,
      'rack.multithread' => true,
      'rack.multiprocess' => false,
      'rack.run_once' => false,
      'CONTENT_TYPE' => 'application/json',
      'CONTENT_LENGTH' => json.bytesize.to_s
    }.merge(options)
  end
end
