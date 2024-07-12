module TestHelpers
  module Events
    class Base

      class_attribute :event, instance_writer: false
      self.event = Hash.new

      def self.create(overrides = {})
        event.deep_merge(overrides.stringify_keys)
      end

    end
  end
end
