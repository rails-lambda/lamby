namespace :lamby do
  task :proxy_server => [:environment] do
    require 'webrick'
    port = ENV['LAMBY_PROXY_PORT'] || 3000
    Rack::Handler::WEBrick.run Lamby::ProxyServer.new, Port: port
  end
end
