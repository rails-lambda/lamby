module Lamby
  class Railtie < ::Rails::Railtie
    config.lamby = Lamby::Config.config

    rake_tasks do
      load 'lamby/tasks.rake'
    end
  end
end
