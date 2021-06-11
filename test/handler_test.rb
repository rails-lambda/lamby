require 'test_helper'

class HandlerTest < LambySpec

  let(:app)     { Rack::Builder.new { run Rails.application }.to_app }
  let(:context) { TestHelpers::LambdaContext.new }

  describe 'http-v2' do

    it 'get' do
      event = TestHelpers::Events::HttpV2.create
      result = Lamby.handler app, event, context, rack: :http
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_match %r{<h1>Hello Lamby</h1>}
      expect(result[:body]).must_match %r{<div id="logged_in">false</div>}
    end

    it 'get - multiple cookies' do
      event = TestHelpers::Events::HttpV2.create(
        'rawPath' => '/production/cooks',
        'requestContext' => { 'http' => {'path' => '/production/cooks'} }
      )
      result = Lamby.handler app, event, context, rack: :http
      expect(result[:statusCode]).must_equal 200
      expect(result[:headers]['Set-Cookie']).must_be_nil
      expect(result[:cookies]).must_equal ["1=1; path=/", "2=2; path=/"]
      expect(result[:body]).must_match %r{<h1>Hello Lamby</h1>}
    end

    it 'get - image' do
      event = TestHelpers::Events::HttpV2.create(
        'rawPath' => '/production/image',
        'requestContext' => { 'http' => {'path' => '/production/image'} }
      )
      result = Lamby.handler app, event, context, rack: :http
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_equal encode64(dummy_app_image)
      expect(result[:headers]['Content-Type']).must_equal 'image/png'
      expect(result[:isBase64Encoded]).must_equal true
      # Public file server.
      event = TestHelpers::Events::HttpV2.create(
        'rawPath' => '/production/1-public.png',
        'requestContext' => { 'http' => {'path' => '/production/1-public.png'} }
      )
      result = Lamby.handler app, event, context, rack: :http
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_equal encode64(dummy_app_image_public), 'not'
      expect(result[:headers]['Content-Type']).must_equal 'image/png'
      expect(result[:headers]['Cache-Control']).must_equal 'public, max-age=2592000'
      expect(result[:headers]['X-Lamby-Base64']).must_equal '1'
      expect(result[:isBase64Encoded]).must_equal true
    end

    it 'post - login' do
      event = TestHelpers::Events::HttpV2Post.create
      result = Lamby.handler app, event, context, rack: :http
      expect(result[:statusCode]).must_equal 302
      expect(result[:body]).must_match %r{https://myawesomelambda.example.com}
      expect(result[:headers]['Location']).must_equal 'https://myawesomelambda.example.com/'
      # Check logged in state via GET.
      event = TestHelpers::Events::HttpV2.create(
        'cookies' => [session_cookie(result)]
      )
      result = Lamby.handler app, event, context, rack: :http
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_match %r{<div id="logged_in">true</div>}
    end

    it 'get - exception' do
      event = TestHelpers::Events::HttpV2.create(
        'rawPath' => '/production/exception',
        'requestContext' => { 'http' => {'path' => '/production/exception'} }
      )
      result = Lamby.handler app, event, context, rack: :http
      expect(result[:statusCode]).must_equal 500
      expect(result[:body]).must_match %r{We're sorry, but something went wrong.}
      expect(result[:body]).must_match %r{This file lives in public/500.html}
    end

  end

  describe 'http-v1' do

    it 'get' do
      event = TestHelpers::Events::HttpV1.create
      result = Lamby.handler app, event, context, rack: :http
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_match %r{<h1>Hello Lamby</h1>}
      expect(result[:body]).must_match %r{<div id="logged_in">false</div>}
    end

    it 'get - multiple cookies' do
      event = TestHelpers::Events::HttpV1.create(
        'path' => '/production/cooks',
        'requestContext' => { 'path' => '/production/cooks'}
      )
      result = Lamby.handler app, event, context, rack: :http
      expect(result[:statusCode]).must_equal 200
      expect(result[:headers]['Set-Cookie']).must_be_nil
      expect(result[:multiValueHeaders]['Set-Cookie']).must_equal ["1=1; path=/", "2=2; path=/"]
      expect(result[:body]).must_match %r{<h1>Hello Lamby</h1>}
    end

    it 'get - image' do
      event = TestHelpers::Events::HttpV1.create(
        'path' => '/production/image',
        'requestContext' => { 'path' => '/production/image' }
      )
      result = Lamby.handler app, event, context, rack: :http
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_equal encode64(dummy_app_image)
      expect(result[:headers]['Content-Type']).must_equal 'image/png'
      # Public file server.
      event = TestHelpers::Events::HttpV1.create(
        'path' => '/production/1-public.png',
        'requestContext' => { 'path' => '/production/1-public.png' }
      )
      result = Lamby.handler app, event, context, rack: :http
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_equal encode64(dummy_app_image_public), 'not'
      expect(result[:headers]['Content-Type']).must_equal 'image/png'
      expect(result[:headers]['Cache-Control']).must_equal 'public, max-age=2592000'
      expect(result[:headers]['X-Lamby-Base64']).must_equal '1'
      expect(result[:isBase64Encoded]).must_equal true
    end

    it 'post - login' do
      event = TestHelpers::Events::HttpV1Post.create
      result = Lamby.handler app, event, context, rack: :http
      expect(result[:statusCode]).must_equal 302
      expect(result[:body]).must_match %r{https://myawesomelambda.example.com}
      expect(result[:headers]['Location']).must_equal 'https://myawesomelambda.example.com/'
      # Check logged in state via GET.
      event = TestHelpers::Events::HttpV1.create(
        'headers' => { 'cookie' => session_cookie(result) },
        'multiValueHeaders' => { 'cookie' => [ session_cookie(result) ]}
      )
      result = Lamby.handler app, event, context, rack: :http
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_match %r{<div id="logged_in">true</div>}
    end

    it 'get - exception' do
      event = TestHelpers::Events::HttpV1.create(
        'path' => '/production/exception',
        'requestContext' => { 'path' => '/production/exception' }
      )
      result = Lamby.handler app, event, context, rack: :http
      expect(result[:statusCode]).must_equal 500
      expect(result[:body]).must_match %r{We're sorry, but something went wrong.}
      expect(result[:body]).must_match %r{This file lives in public/500.html}
    end

  end

  describe 'rest' do

    it 'get' do
      event = TestHelpers::Events::Rest.create
      result = Lamby.handler app, event, context, rack: :rest
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_match %r{<h1>Hello Lamby</h1>}
      expect(result[:body]).must_match %r{<div id="logged_in">false</div>}
    end

    it 'get - multiple cookies' do
      event = TestHelpers::Events::Rest.create(
        'path' => '/cooks',
        'requestContext' => { 'path' => '/cooks'}
      )
      result = Lamby.handler app, event, context, rack: :rest
      expect(result[:statusCode]).must_equal 200
      expect(result[:headers]['Set-Cookie']).must_be_nil
      expect(result[:multiValueHeaders]['Set-Cookie']).must_equal ["1=1; path=/", "2=2; path=/"]
      expect(result[:body]).must_match %r{<h1>Hello Lamby</h1>}
    end

    it 'get - image' do
      event = TestHelpers::Events::Rest.create(
        'path' => '/image',
        'requestContext' => { 'path' => '/image' }
      )
      result = Lamby.handler app, event, context, rack: :rest
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_equal encode64(dummy_app_image)
      expect(result[:headers]['Content-Type']).must_equal 'image/png'
      # Public file server.
      event = TestHelpers::Events::Rest.create(
        'path' => '/1-public.png',
        'requestContext' => { 'path' => '/1-public.png' }
      )
      result = Lamby.handler app, event, context, rack: :rest
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_equal encode64(dummy_app_image_public), 'not'
      expect(result[:headers]['Content-Type']).must_equal 'image/png'
      expect(result[:headers]['Cache-Control']).must_equal 'public, max-age=2592000'
      expect(result[:headers]['X-Lamby-Base64']).must_equal '1'
      expect(result[:isBase64Encoded]).must_equal true
    end

    it 'post - login' do
      event = TestHelpers::Events::RestPost.create
      result = Lamby.handler app, event, context, rack: :rest
      expect(result[:statusCode]).must_equal 302
      expect(result[:body]).must_match %r{https://myawesomelambda.example.com}
      expect(result[:headers]['Location']).must_equal 'https://myawesomelambda.example.com/'
      # Check logged in state via GET.
      event = TestHelpers::Events::Rest.create(
        'headers' => { 'Cookie' => session_cookie(result) },
        'multiValueHeaders' => { 'Cookie' => [ session_cookie(result) ]}
      )
      result = Lamby.handler app, event, context, rack: :rest
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_match %r{<div id="logged_in">true</div>}
    end

    it 'get - exception' do
      event = TestHelpers::Events::Rest.create(
        'path' => '/exception',
        'requestContext' => { 'path' => '/exception' }
      )
      result = Lamby.handler app, event, context, rack: :rest
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

    it 'get - multiple cookies' do
      event = TestHelpers::Events::Alb.create 'path' => '/cooks'
      result = Lamby.handler app, event, context, rack: :rest
      expect(result[:statusCode]).must_equal 200
      expect(result[:headers]['Set-Cookie']).must_be_nil
      expect(result[:multiValueHeaders]['Set-Cookie']).must_equal ["1=1; path=/", "2=2; path=/"]
      expect(result[:body]).must_match %r{<h1>Hello Lamby</h1>}
    end

    it 'get - image' do
      event = TestHelpers::Events::Alb.create 'path' => '/image'
      result = Lamby.handler app, event, context, rack: :alb
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_equal encode64(dummy_app_image)
      expect(result[:headers]['Content-Type']).must_equal 'image/png'
      event = TestHelpers::Events::Alb.create 'path' => '/1-public.png'
      result = Lamby.handler app, event, context, rack: :alb
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_equal encode64(dummy_app_image_public), 'not'
      expect(result[:headers]['Content-Type']).must_equal 'image/png'
      expect(result[:headers]['Cache-Control']).must_equal 'public, max-age=2592000'
      expect(result[:headers]['X-Lamby-Base64']).must_equal '1'
      expect(result[:isBase64Encoded]).must_equal true
    end

    it 'get - exception' do
      event = TestHelpers::Events::Alb.create(
        'path' => '/exception',
        'requestContext' => { 'path' => '/exception' }
      )
      result = Lamby.handler app, event, context, rack: :alb
      expect(result[:statusCode]).must_equal 500
      expect(result[:body]).must_match %r{We're sorry, but something went wrong.}
      expect(result[:body]).must_match %r{This file lives in public/500.html}
    end

  end

  describe 'event_bridge' do

    let(:event) do
      {
        "version" => "0",
        "id"=>"0874bcac-1dac-2393-637f-201025f217b0",
        "detail-type"=>"orderCreated",
        "source"=>"com.myorg.stores",
        "account"=>"123456789012",
        "time"=>"2021-04-29T13:51:41Z",
        "region"=>"us-east-1",
        "resources"=>[],
        "detail"=>{"id" => "123"}
      }
    end

    it 'has a configurable proc' do
      expect(Lamby.config.event_bridge_handler).must_be_instance_of Proc
      Lamby.config.event_bridge_handler = lambda { |e,c| "#{e}#{c}" }
      r = Lamby.config.event_bridge_handler.call(1,2)
      expect(r).must_equal '12'
    end

    it 'basic event puts to log' do
      out = capture(:stdout) { @result = Lamby.handler app, event, context }
      expect(out).must_match %r{0874bcac-1dac-2393-637f-201025f217b0}
    end

    it 'basic event with Lambdakiq' do
      require 'lambdakiq'

      out = capture(:stdout) { @result = Lamby.handler app, event, context }
      expect(out).must_match %r{0874bcac-1dac-2393-637f-201025f217b0}

      # Unload the best we can
      Object.send(:remove_const, :Lambdakiq)
      ActiveJob::QueueAdapters.send(:remove_const, 'LambdakiqAdapter')
    end
  end

  describe 'runner' do

    it 'migrate pattern runs' do
      event = { 'lamby' => { 'runner' => './bin/rake db:migrate' } }
      out = capture(:stdout) { @result = Lamby.handler app, event, context, rack: :http }
      expect(out).must_match %r{Don't know how to build task 'db:migrate'}
      expect(@result[:statusCode]).must_equal 1
      expect(@result[:headers]).must_equal({})
      expect(@result[:body]).must_match %r{Don't know how to build task 'db:migrate'}
    end

    it 'raises an UnknownCommandPattern error for unknown patterns' do
      event = { 'lamby' => { 'runner' => 'ls -lAGp' } }
      error = assert_raises Lamby::Runner::UnknownCommandPattern do
        Lamby.handler app, event, context
      end
      expect(error.message).must_equal 'ls -lAGp'
    end

    it 'can push other command patterns' do
      # Using Regular Expression
      Lamby.config.runner_patterns.push %r{\A/bin/foo.*}
      event = { 'lamby' => { 'runner' => '/bin/foo hello' } }
      error = assert_raises Errno::ENOENT do
        Lamby.handler app, event, context
      end
      expect(error.message).must_match 'No such file or directory'
      # Using String Equality
      Lamby.config.runner_patterns.push './bin/rake some:task'
      event = { 'lamby' => { 'runner' => './bin/rake some:task' } }
      out = capture(:stdout) { Lamby.handler app, event, context }
      expect(out).must_match "Don't know how to build task"
    end

  end

  private

  def session_cookie(result)
    cookies = (result[:cookies] || result[:multiValueHeaders]['Set-Cookie'])[0]
    cookies.split('; ').detect { |x| x =~ /session=/ }
  end

end
