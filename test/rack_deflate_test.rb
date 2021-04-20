require 'test_helper'

class RackDeflateTest < LambySpec

  let(:app)     { Rack::Builder.new { run Rails.application }.to_app }
  let(:context) { TestHelpers::LambdaContext.new }

  it 'get - Rest' do
    event = TestHelpers::Events::Rest.create
    result = Lamby.handler app, event, context, rack: :rest
    expect(result[:statusCode]).must_equal 200
  end

  it 'get - Rest with redirect' do
    event = TestHelpers::Events::Rest.create(
      'path' => '/redirect_test',
      'requestContext' => { 'path' => '/redirect_test'}
    )
    result = Lamby.handler app, event, context, rack: :rest
    expect(result[:statusCode]).must_equal 301
    refute result[:headers]['Location'].nil?
  end

  it 'get - HttpV1' do
    event = TestHelpers::Events::HttpV1.create
    result = Lamby.handler app, event, context, rack: :http
    expect(result[:statusCode]).must_equal 200
  end

  it 'get - HttpV1 with redirect' do
    event = TestHelpers::Events::HttpV1.create(
      'path' => '/production/redirect_test',
      'requestContext' => { 'path' => '/production/redirect_test'}
    )
    result = Lamby.handler app, event, context, rack: :http
    expect(result[:statusCode]).must_equal 301
    refute result[:headers]['Location'].nil?
  end

  it 'get - HttpV2' do
    event = TestHelpers::Events::HttpV2.create
    result = Lamby.handler app, event, context, rack: :http
    expect(result[:statusCode]).must_equal 200
  end

  it 'get - HttpV2 with redirect' do
    event = TestHelpers::Events::HttpV2.create(
      'rawPath' => '/production/redirect_test',
      'requestContext' => { 'http' => {'path' => '/production/redirect_test'} }
    )
    result = Lamby.handler app, event, context, rack: :http
    expect(result[:statusCode]).must_equal 301
    refute result[:headers]['Location'].nil?
  end

  it 'get - Alb' do
    event = TestHelpers::Events::Alb.create
    result = Lamby.handler app, event, context, rack: :alb
    expect(result[:statusCode]).must_equal 200
  end

  it 'get - Alb with redirect' do
    event = TestHelpers::Events::Alb.create 'path' => '/redirect_test'
    result = Lamby.handler app, event, context, rack: :alb
    expect(result[:statusCode]).must_equal 301
    refute result[:headers]['Location'].nil?
  end

end
