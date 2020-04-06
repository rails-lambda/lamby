ENV['LAMBY_TEST'] = '1'
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'lamby'
require 'pry'
require 'minitest/autorun'
require 'minitest/focus'
require 'mocha/minitest'
require 'dummy_app/init'
require 'test_helper/dummy_app_helpers'
require 'test_helper/stream_helpers'
require 'test_helper/lambda_context'
require 'test_helper/event_helpers'

Rails.backtrace_cleaner.remove_silencers!

class LambySpec < Minitest::Spec
  include TestHelpers::DummyAppHelpers,
          TestHelpers::StreamHelpers

  before do
    delete_dummy_files
  end

  after do
    delete_dummy_files
  end

  private

  def encode64(v)
    Base64.strict_encode64(v)
  end
end
