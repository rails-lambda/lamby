$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'lamby'
require 'pry'
require 'minitest/autorun'
require 'mocha/minitest'
require 'dummy_app/init'
require 'test_helper/dummy_app_helpers'
require 'test_helper/stream_helpers'

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
end
