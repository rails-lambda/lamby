namespace :lamby do
  task :proxy_server => [:environment] do
    require 'webrick'
    port = ENV['LAMBY_PROXY_PORT'] || 3000
    bind = ENV['LAMBY_PROXY_BIND'] || '0.0.0.0'
    Rack::Handler::WEBrick.run Lamby::ProxyServer.new, Port: port, BindAddress: bind
  end

  task :proxy_server_puma => [:environment] do
    port = ENV['LAMBY_PROXY_PORT'] || 3000
    host = ENV['LAMBY_PROXY_BIND'] || '0.0.0.0'
    server = Puma::Server.new(Lamby::ProxyServer.new)
    server.add_tcp_listener host, port
    server.run.join
  end
end
