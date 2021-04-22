require 'open3'

module Lamby
  class Runner

    class << self

      def handle?(event)
        event.dig 'lamby', 'runner'
      end

      def call(event)
        new(event).call
      end

    end

    def initialize(event)
      @event = event
    end

    def call
      status = Open3.popen3(command) do |_stdin, stdout, stderr, thread|
        puts stdout.read
        puts stderr.read
        thread.value.exitstatus
      end
      [status, {}, StringIO.new('')]
    end

    def command
      @event.dig 'lamby', 'runner'
    end

  end
end
