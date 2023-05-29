namespace :lamby do
  task :proxy_server => [:environment] do
    require 'webrick'
    port = ENV['LAMBY_PROXY_PORT'] || 3000
    bind = ENV['LAMBY_PROXY_BIND'] || '0.0.0.0'
    Rack::Handler::WEBrick.run Lamby::ProxyServer.new, Port: port, BindAddress: bind
  end
end
