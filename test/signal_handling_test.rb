require 'test_helper'

class SignalHandlingTest < LambySpec
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
end