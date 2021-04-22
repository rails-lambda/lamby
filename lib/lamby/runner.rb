require 'open3'

module Lamby
  class Runner
    class Error < StandardError ; end
    class UnknownCommandPattern < Error ; end

    PATTERNS = [
      %r{\A\./bin/(rails|rake) db:migrate.*}
    ]

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
      validate!
      status = Open3.popen3(command, chdir: chdir) do |_stdin, stdout, stderr, thread|
        puts stdout.read
        puts stderr.read
        thread.value.exitstatus
      end
      [status, {}, StringIO.new('')]
    end

    def command
      @event.dig 'lamby', 'runner'
    end

    private

    def chdir
      defined?(::Rails) ? ::Rails.root : Dir.pwd
    end

    def validate!
      return if pattern?
      raise UnknownCommandPattern.new(command)
    end

    def pattern?
      PATTERNS.any? { |p| p === command }
    end

  end
end
