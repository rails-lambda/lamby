module Lamby
  module Debug
    include Lamby::SamHelpers

    extend self

    def on?(event)
      params = event['queryStringParameters']
      (Rails.env.development? || ENV['LAMBY_DEBUG']) && params && params['debug'] == '1'
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
            <h2>Environment</h2>
            <pre>
              #{sam_local? ? JSON.pretty_generate(ENV.to_h) : 'N/A'}
            </pre>
          </body>
        </html>
      HTML
    end

  end
end
