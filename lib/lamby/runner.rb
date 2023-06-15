require 'open3'

module Lamby
  class Runner
    class Error < StandardError ; end
    class UnknownCommandPattern < Error ; end

    PATTERNS = [%r{.*}]

    class << self

      def handle?(event)
        event.dig('x-lambda-console', 'runner') ||
          event.dig('lamby', 'runner')
      end

      def cmd(event:, context:)
        new(event).call
      end

    end

    def initialize(event)
      @event = event
      @body = ''
    end

    def call
      validate!
      status = Open3.popen3(env, command, chdir: chdir) do |_stdin, stdout, stderr, thread|
        @body << stdout.read
        @body << stderr.read
        puts @body
        thread.value.exitstatus
      end
      { statusCode: status, headers: {}, body: @body }
    end

    def command
      @event.dig('x-lambda-console', 'runner') ||
        @event.dig('lamby', 'runner')
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

    def env
      Hash[ENV.to_hash.map { |k,v| [k, ENV[k]] }]
    end

  end
end
