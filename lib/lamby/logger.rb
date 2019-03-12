require 'logger'

ENV['RAILS_LOG_TO_STDOUT'] = '1'

module Lamby
  module Logger

    def initialize(*args)
      args[0] = STDOUT
      super(*args)
    end

  end
end

Logger.prepend Lamby::Logger

# TODO: Railtie initializer
# Rails.application.config.logger = ActiveSupport::TaggedLogging.new(
#   ActiveSupport::Logger.new(STDOUT).tap { |logger|
#     logger.formatter = Rails.application.config.log_formatter
#   }
# )
