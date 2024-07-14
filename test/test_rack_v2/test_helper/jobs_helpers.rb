module TestHelpers
  module Jobs
    class BasicJob < ActiveJob::Base
      def perform(object)
        puts "BasicJob with: #{object.inspect}"
      end
    end
  end
end
