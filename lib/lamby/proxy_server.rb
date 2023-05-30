module Lamby
  class ProxyServer
    
    METHOD_NOT_ALLOWED = <<-HEREDOC.strip
      <h1>Method Not Allowed</h1>
      <p>Please POST to this endpoint with an application/json content type and JSON payload of your Lambda's event and context.<p>
      <p>Example: <code>{ "event": event, "context": context }</code></p>
    HEREDOC
    
    def call(env)
      return method_not_allowed unless method_allowed?(env)
      event, context = event_and_context(env)
      lambda_to_rack Lamby.cmd(event: event, context: context)
    end

    private

    def event_and_context(env)
      data = env['rack.input'].dup.read
      json = JSON.parse(data)
      [ json['event'], Lamby::ProxyContext.new(json['context']) ]
    end

    def method_allowed?(env)
      env['REQUEST_METHOD'] == 'POST' && env['CONTENT_TYPE'] == 'application/json'
    end

    def method_not_allowed
      [405, {"Content-Type" => "text/html"}, [ METHOD_NOT_ALLOWED.dup ]]
    end

    def lambda_to_rack(response)
      [ 200, {"Content-Type" => "application/json"}, [ response.to_json ] ]
    end
  end
end
