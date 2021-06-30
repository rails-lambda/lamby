require 'logger'

unless ENV['LAMBY_TEST']

  ENV['RAILS_LOG_TO_STDOUT'] = '1'

  module Lamby
    module Logger

      def initialize(*args, **kwargs)
        args[0] = STDOUT
        super(*args, **kwargs)
      end

    end
  end

  Logger.prepend Lamby::Logger

end

# TODO: Railtie initializer
# Rails.application.config.logger = ActiveSupport::TaggedLogging.new(
#   ActiveSupport::Logger.new(STDOUT).tap { |logger|
#     logger.formatter = Rails.application.config.log_formatter
#   }
# )
