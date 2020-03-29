require 'test_helper'

class HandlerTest < LambySpec

  let(:app)     { Rack::Builder.new { run Rails.application }.to_app }
  let(:context) { TestHelpers::LambdaContext.new }

  describe 'rest' do

    it 'get' do
      event = TestHelpers::Events::Rest.create
      result = Lamby.handler app, event, context, rack: :api
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_match %r{<h1>Hello Lamby</h1>}
      expect(result[:body]).must_match %r{<div id="logged_in">false</div>}
    end

    it 'get - image' do
      event = TestHelpers::Events::Rest.create(
        'path' => '/image',
        'requestContext' => { 'path' => '/image' }
      )
      result = Lamby.handler app, event, context, rack: :api
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_equal dummy_app_image
      expect(result[:headers]['Content-Type']).must_equal 'image/png'
    end

    it 'post - login' do
      event = TestHelpers::Events::RestPost.create
      result = Lamby.handler app, event, context, rack: :api
      expect(result[:statusCode]).must_equal 302
      expect(result[:body]).must_match %r{https://myawesomelambda.example.com}
      expect(result[:headers]['Location']).must_equal 'https://myawesomelambda.example.com/'
      # Check logged in state via GET.
      event = TestHelpers::Events::Rest.create(
        'headers' => { 'Cookie' => session_cookie(result) },
        'multiValueHeaders' => { 'Cookie' => [ session_cookie(result) ]}
      )
      result = Lamby.handler app, event, context, rack: :api
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_match %r{<div id="logged_in">true</div>}
    end

    it 'get - exception' do
      event = TestHelpers::Events::Rest.create(
        'path' => '/exception',
        'requestContext' => { 'path' => '/exception' }
      )
      result = Lamby.handler app, event, context, rack: :api
      expect(result[:statusCode]).must_equal 500
      expect(result[:body]).must_match %r{We're sorry, but something went wrong.}
      expect(result[:body]).must_match %r{This file lives in public/500.html}
    end

  end

  describe 'alb' do

    it 'get' do
      event = TestHelpers::Events::Alb.create
      result = Lamby.handler app, event, context, rack: :alb
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_match %r{<h1>Hello Lamby</h1>}
      expect(result[:body]).must_match %r{<div id="logged_in">false</div>}
    end

    it 'get - image' do
      event = TestHelpers::Events::Alb.create 'path' => '/image'
      result = Lamby.handler app, event, context, rack: :alb
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_equal Base64.strict_encode64(dummy_app_image)
      expect(result[:headers]['Content-Type']).must_equal 'image/png'
    end

    it 'get - exception' do
      event = TestHelpers::Events::Alb.create(
        'path' => '/exception',
        'requestContext' => { 'path' => '/exception' }
      )
      result = Lamby.handler app, event, context, rack: :api
      expect(result[:statusCode]).must_equal 500
      expect(result[:body]).must_match %r{We're sorry, but something went wrong.}
      expect(result[:body]).must_match %r{This file lives in public/500.html}
    end

  end

  private

  def session_cookie(result)
    cookies = result[:headers]['Set-Cookie']
    cookies.split('; ').detect { |x| x =~ /session=/ }
  end

end
