installers = {
  'API Gateway': :api_gateway
}.freeze

namespace :lamby do
  namespace :install do

    installers.each do |name, task_name|
      desc "Install Lamby files for #{name}"
      task task_name do
        exec "#{base_path} LOCATION=#{template(task_name)}"
      end
    end

    def template(task_name)
      File.expand_path "../lamby/templates/#{task_name}.rb", __dir__
    end

    def bin_path
      ENV['BUNDLE_BIN'] || './bin'
    end

    def base_path
      if Rails::VERSION::MAJOR >= 5
        "#{RbConfig.ruby} #{bin_path}/rails app:template"
      else
        "#{RbConfig.ruby} #{bin_path}/rake rails:template"
      end
    end

  end

  desc "Install Lamby files for #{installers.first.first}"
  task install: 'install:api_gateway'
end


