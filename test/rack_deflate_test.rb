require 'test_helper'

class RackDeflateTest < LambySpec

  let(:app)     { Rack::Builder.new { run Rails.application }.to_app }
  let(:context) { TestHelpers::LambdaContext.new }

  describe 'Using Rack Deflate Middleware' do

    it 'get' do
      event = TestHelpers::Events::HttpV2.create
      result = Lamby.handler app, event, context, rack: :http
      expect(result[:statusCode]).must_equal 200
    end

    it 'get - test redirect' do
      event = TestHelpers::Events::HttpV2.create(
        'rawPath' => '/production/redirect_test',
        'requestContext' => { 'http' => {'path' => '/production/redirect_test'} }
      )
      result = Lamby.handler app, event, context, rack: :http
      expect(result[:statusCode]).must_equal 301
      refute result[:headers]['Location'].nil?
    end
    
  end
  
end
