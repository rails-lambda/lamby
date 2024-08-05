require 'net/http'
require 'test_helper'

class ProxyServerTest < LambySpec
  include Rack::Test::Methods

  let(:event)    { TestHelpers::Events::HttpV2.create }
  let(:context)  { TestHelpers::LambdaContext.raw_data }
  let(:app)      { Rack::Builder.new { run Lamby::ProxyServer.new }.to_app }
  let(:json)     { {"event": event, "context": context}.to_json }

  it 'should return a 405 helpful message on GET' do
    response = get '/'
    expect(response.status).must_equal 405
    expect(response.headers).must_equal({"content-type"=>"text/html", "content-length"=>"233"})
    expect(response.body).must_include 'Method Not Allowed'
  end
  
  it 'should call Lamby.cmd on POST and include full response as JSON' do
    response = post '/', json, 'CONTENT_TYPE' => 'application/json'
    expect(response.status).must_equal 200
    expect(response.headers).must_equal({"content-type"=>"application/json", "content-length"=>"740"})
    response_body = JSON.parse(response.body)
    expect(response_body['statusCode']).must_equal 200
    expect(response_body['headers']).must_be_kind_of Hash
    expect(response_body['body']).must_match 'Hello Lamby'
  end

  it 'will return whatever Lamby.cmd does' do
    Lamby.stubs(:cmd).returns({statusCode: 200})
    response = post '/', json, 'CONTENT_TYPE' => 'application/json'
    expect(response.status).must_equal 200
    expect(response.headers).must_equal({"content-type"=>"application/json", "content-length"=>"18"})
    response_body = JSON.parse(response.body)
    expect(response_body['statusCode']).must_equal 200
    expect(response_body['headers']).must_be_nil
    expect(response_body['body']).must_be_nil
  end

  it 'will use the configured Lamby rack_app' do
    rack_app = Rack::Builder.new { run lambda { |env| [200, {}, StringIO.new('OK')] } }.to_app
    Lamby.config.rack_app = rack_app
    response = post '/', json, 'CONTENT_TYPE' => 'application/json'
    expect(response.status).must_equal 200
    expect(response.headers).must_equal({"content-type"=>"application/json", "content-length"=>"43"})
    response_body = JSON.parse(response.body)
    expect(response_body['statusCode']).must_equal 200
    expect(response_body['headers']).must_equal({})
    expect(response_body['body']).must_equal('OK')
  end

end
