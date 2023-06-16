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
    
    it 'head' do
      event = TestHelpers::Events::HttpV2.create(
        'requestContext' => {'http' => {'method' => 'HEAD'}},
        'body' => nil
      )
      result = Lamby.handler app, event, context, rack: :http
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_equal ""
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

    it 'head' do
      event = TestHelpers::Events::HttpV1.create(
        'httpMethod' => 'HEAD',
        'requestContext' => {'httpMethod' => 'HEAD'},
        'body' => nil
      )
      result = Lamby.handler app, event, context, rack: :http
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_equal ""
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

    it 'head' do
      event = TestHelpers::Events::Rest.create(
        'httpMethod' => 'HEAD',
        'body' => nil
      )
      result = Lamby.handler app, event, context, rack: :rest
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_equal ""
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
    
    it 'head' do
      event = TestHelpers::Events::Alb.create(
        'httpMethod' => 'HEAD',
        'body' => nil
      )
      result = Lamby.handler app, event, context, rack: :alb
      expect(result[:statusCode]).must_equal 200
      expect(result[:body]).must_equal ""
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

  end

  describe 'lambdakiq' do

    let(:event) do
      { 
        "Records" => [
          {
            "messageId" => "9081fe74-bc79-451f-a03a-2fe5c6e2f807", 
            "receiptHandle" => "AQEBgbn8GmF1fMo4z3IIqlJYymS6e7NBynwE+LsQlzjjdcKtSIomGeKMe0noLC9UDShUSe8bzr0s+pby03stHNRv1hgg4WRB5YT4aO0dwOuio7LvMQ/VW88igQtWmca78K6ixnU9X5Sr6J+/+WMvjBgIdvO0ycAM2tyJ1nxRHs/krUoLo/bFCnnwYh++T5BLQtFjFGrRkPjWnzjAbLWKU6Hxxr5lkHSxGhjfAoTCOjhi9crouXaWD+H1uvoGx/O/ZXaeMNjKIQoKjhFguwbEpvrq2Pfh2x9nRgBP3cKa9qw4Q3oFQ0MiQAvnK+UO8cCnsKtD", 
            "body" => "{\"job_class\":\"TestHelpers::Jobs::BasicJob\",\"job_id\":\"527cd37e-08f4-4aa8-9834-a46220cdc5a3\",\"provider_job_id\":null,\"queue_name\":\"lambdakiq-JobsQueue-TESTING123.fifo\",\"priority\":null,\"arguments\":[\"test\"],\"executions\":0,\"exception_executions\":{},\"locale\":\"en\",\"timezone\":\"UTC\",\"enqueued_at\":\"2020-11-30T13:07:36Z\"}", 
            "attributes" => {
              "ApproximateReceiveCount" => "1", 
              "SentTimestamp" => "1606741656429", 
              "SequenceNumber" => "18858069937755376128", 
              "MessageGroupId" => "527cd37e-08f4-4aa8-9834-a46220cdc5a3", 
              "SenderId" => "AROA4DJKY67RBVYCN5UZ3", 
              "MessageDeduplicationId" => "527cd37e-08f4-4aa8-9834-a46220cdc5a3", 
              "ApproximateFirstReceiveTimestamp" => "1606741656429"
            }, 
            "messageAttributes" => {
              "lambdakiq" => {
                "stringValue" => "1", 
                "stringListValues" => [], 
                "binaryListValues" => [], 
                "dataType" => "String"
              }
            },
            "md5OfMessageAttributes" => "5fde2d817e4e6b7f28735d3b1725f817", 
            "md5OfBody" => "6477b54fb64dde974ea7514e87d3b8a5", 
            "eventSource" => "aws:sqs", 
            "eventSourceARN" => "arn:aws:sqs:us-east-1:831702759394:lambdakiq-JobsQueue-TESTING123.fifo", "awsRegion" => "us-east-1"
          }
        ]
      }
    end

    it 'basic event' do
      out = capture(:stdout) { @result = Lamby.handler app, event, context }
      expect(out).must_match %r{BasicJob with: "test"}
      expect(@result).must_be_instance_of Hash
      expect(@result[:batchItemFailures]).must_be_instance_of Array
      expect(@result[:batchItemFailures]).must_be_empty
    end

  end

  describe 'LambdaConsole' do

    after do
      Lamby.config.runner_patterns.push %r{.*}
    end

    it 'run' do
      event = { 'X_LAMBDA_CONSOLE' => { 'run' => %q|echo 'hello'| } }
      result = Lamby.handler app, event, context
      expect(result[:statusCode]).must_equal 0
      expect(result[:headers]).must_equal({})
      expect(result[:body]).must_match %r{hello}
    end

    it 'run with error' do
      event = { 'X_LAMBDA_CONSOLE' => { 'run' => %q|/usr/bin/doesnotexist| } }
      result = Lamby.handler app, event, context
      expect(result[:statusCode]).must_equal 1
      expect(result[:headers]).must_equal({})
      expect(result[:body]).must_match %r{No such file or directory}
    end

    it 'run with pattern' do
      Lamby.config.runner_patterns.clear
      event = { 'X_LAMBDA_CONSOLE' => { 'run' => %q|echo 'hello'| } }
      error = assert_raises LambdaConsole::Run::UnknownCommandPattern do
        Lamby.handler app, event, context
      end
      expect(error.message).must_equal %|echo 'hello'|
    end

    it 'interact' do
      event = { 'X_LAMBDA_CONSOLE' => { 'interact' => 'Object.new' } }
      result = Lamby.handler app, event, context
      expect(result[:statusCode]).must_equal 200
      expect(result[:headers]).must_equal({})
      expect(result[:body]).must_match %r{#<Object:.*>}
    end

    it 'interact with error' do
      event = { 'X_LAMBDA_CONSOLE' => { 'interact' => 'raise("hell")' } }
      result = Lamby.handler app, event, context
      expect(result[:statusCode]).must_equal 422
      expect(result[:headers]).must_equal({})
      expect(result[:body]).must_match %r{#<RuntimeError:hell>}
    end

  end

  private

  def session_cookie(result)
    cookies = (result[:cookies] || result[:multiValueHeaders]['Set-Cookie'])[0]
    cookies.split('; ').detect { |x| x =~ /session=/ }
  end

end
