require 'logger'

if ENV['AWS_EXECUTION_ENV']
  ENV['RAILS_LOG_TO_STDOUT'] = '1' 

  module Lamby
    module Logger

      def initialize(*args, **kwargs)
        args[0] = STDOUT
        super(*args, **kwargs)
      end

    end
  end

  Logger.prepend Lamby::Logger unless ENV['LAMBY_TEST']
end
