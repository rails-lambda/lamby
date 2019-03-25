module Lamby
  class Railtie < ::Rails::Railtie

    config.lamby = ActiveSupport::OrderedOptions.new

    rake_tasks do
      load 'lamby/tasks.rake'
    end

  end
end
