require "test_helper"

class LambyTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Lamby::VERSION
  end
end
