module Lamby
  class Command

    class << self

      def handle?(event)
        event.dig 'lamby', 'command'
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
      begin
        body = eval(command, TOPLEVEL_BINDING).to_s
        body = body.inspect if body =~ /\A"/ && body =~ /"\z/
        { statusCode: 200, headers: {}, body: body }
      rescue Exception => e
        body = "#<#{e.class}:#{e.message}>".tap do |b|
          if e.backtrace
            b << "\n"
            b << e.backtrace.join("\n")
          end
        end
        { statusCode: 422, headers: {}, body: body }
      end
    end

    def command
      @event.dig 'lamby', 'command'
    end

  end
end
