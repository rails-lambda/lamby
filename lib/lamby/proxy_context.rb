module Lamby
  # This class is used by the `lamby:proxy_server` Rake task to run a
  # Rack server for local development proxy. Specifically, this class 
  # accepts a JSON respresentation of a Lambda context object converted 
  # to a Hash as the single arugment.
  # 
  class ProxyContext
    def initialize(data)
      @data = data
    end

    def method_missing(method_name, *args, &block)
      key = method_name.to_s
      if @data.key?(key)
        @data[key]
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @data.key?(method_name.to_s) || super
    end
  end
end
