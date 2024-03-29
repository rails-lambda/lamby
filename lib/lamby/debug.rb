module Lamby
  module Debug
    extend self

    def on?(event)
      params = event['multiValueQueryStringParameters'] || event['queryStringParameters']
      (development? || ENV['LAMBY_DEBUG']) && params && params['debug'] == '1'
    end

    def call(event, context, env)
      [ 200, { 'Content-Type' => 'text/html' }, [body(event, context, env)] ]
    end

    private

    def body(event, context, env)
      <<-HTML
        <!DOCTYPE html>
        <html>
          <body>
            <h1>Lamby Debug Response</h1>
            <h2>Event</h2>
            <pre>
              #{JSON.pretty_generate(event)}
            </pre>
            <h2>Rack Env</h2>
            <pre>
              #{JSON.pretty_generate(env)}
            </pre>
            <h2>#{context.class.name}</h2>
            <code>
              #{CGI::escapeHTML(context.inspect)}
            </code>
          </body>
        </html>
      HTML
    end

    def development?
      ENV.to_h
        .slice('RACK_ENV', 'RAILS_ENV')
        .values
        .any? { |v| v.to_s.casecmp('development').zero? }
    end

  end
end
