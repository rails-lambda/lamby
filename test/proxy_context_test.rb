require 'test_helper'

class ProxyContextTest < LambySpec
  
  let(:context_data) { TestHelpers::LambdaContext.raw_data }
  let(:proxy_context) { Lamby::ProxyContext.new(context_data) }

  it 'should respond to all context methods' do
    context_data.keys.each do |key|
      response = proxy_context.respond_to?(key.to_sym)
      expect(response).must_equal true, "Expected context to respond to #{key.inspect}"
    end
  end

  it 'should return the correct value for each context method' do
    expect(proxy_context.clock_diff).must_equal 1681486457423
    expect(proxy_context.deadline_ms).must_equal 1681492072985
    expect(proxy_context.aws_request_id).must_equal "d6f5961b-5034-4db5-b3a9-fa378133b0f0"
  end

  it 'should raise an error for unknown methods' do
    expect { proxy_context.foo }.must_raise NoMethodError
  end

  it 'should return false for respond_to? for a unknown method' do
    expect(proxy_context.respond_to?(:foo)).must_equal false
  end

end
