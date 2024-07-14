ENV['LAMBY_TEST'] = '1'
ENV['AWS_EXECUTION_ENV'] = 'AWS_Lambda_Image'
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'lamby'
require 'pry'
require 'timecop'
require 'minitest/autorun'
require 'minitest/focus'
require 'mocha/minitest'
require_relative '../dummy_app/init'
require_relative '../test_helper/dummy_app_helpers'
require_relative '../test_helper/stream_helpers'
require_relative '../test_helper/lambda_context'
require_relative '../test_helper/event_helpers'
require_relative '../test_helper/jobs_helpers'
require_relative '../test_helper/lambdakiq_helpers'

Rails.backtrace_cleaner.remove_silencers!
Lambdakiq::Client.default_options.merge! stub_responses: true
Timecop.safe_mode = true

class LambySpec < Minitest::Spec
  include TestHelpers::DummyAppHelpers,
          TestHelpers::StreamHelpers,
          TestHelpers::LambdakiqHelpers

  before do
    Lamby.config.reconfigure
    lambdakiq_client_reset!
    lambdakiq_client_stub_responses
  end

  after do
    Timecop.return
  end

  private

  def encode64(v)
    Base64.strict_encode64(v)
  end
end
