require 'test_helper'

class LambyCoreSpec < LambySpec
  def setup
    @event = { 'httpMethod' => 'GET', 'path' => '/' }
    @context = TestHelpers::LambdaContext.new
  end
  
  it 'has a version number' do
    expect(Lamby::VERSION).wont_be_nil
  end
  
  it 'catches SIGTERM signal' do
    assert_raises(SystemExit) do
      Process.kill('TERM', Process.pid)
      sleep 0.1 # Give time for the signal to be processed
    end
  end

  it 'catches SIGINT signal' do
    assert_raises(SystemExit) do
      Process.kill('INT', Process.pid)
      sleep 0.1 # Give time for the signal to be processed
    end
  end

  it 'executes cmd method' do
    Lamby.config.stubs(:handled_proc).returns(->(_, _) {})
    result = Lamby.cmd(event: @event, context: @context)
  
    assert result.is_a?(Hash), "Expected result to be a Hash, but got #{result.class}"
    assert_equal 200, result[:statusCode], "Expected statusCode to be 200, but got #{result[:statusCode]}"
    assert_includes result[:body], "Hello Lamby", "Expected body to contain 'Hello Lamby'"
  end

  it 'executes handler method' do
    app = Rack::Builder.new do
      run lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ['OK']] }
    end.to_app

    event = {
      'httpMethod' => 'GET',
      'path' => '/',
      'headers' => {},
      'multiValueHeaders' => {},
      'queryStringParameters' => {},
      'multiValueQueryStringParameters' => {},
      'requestContext' => {
        'elb' => {
          'targetGroupArn' => 'arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/myawesomelambda/1234567890abcdef'
        }
      },
      'body' => nil,
      'isBase64Encoded' => false
    }
    result = Lamby.handler(app, event, @context)

    assert result.is_a?(Hash), "Expected result to be a Hash, but got #{result.class}"
    assert_equal 200, result[:statusCode], "Expected statusCode to be 200, but got #{result[:statusCode]}"
    assert_equal 'OK', result[:body], "Expected body to be 'OK', but got #{result[:body]}"
  end

  it 'returns the configuration' do
    config = Lamby.config
    assert config.is_a?(Lamby::Configuration), "Expected config to be an instance of Lamby::Config, but got #{config.class}"
  end
end