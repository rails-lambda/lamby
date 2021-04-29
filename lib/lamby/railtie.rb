module Lamby
  class Railtie < ::Rails::Railtie

    rake_tasks do
      load 'lamby/tasks.rake'
      load 'lamby/templates.rake'
    end

  end
end
