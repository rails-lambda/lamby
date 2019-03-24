namespace :lamby do

  namespace :ssm do

    desc 'Create a Dotenv file '
    task :dotenv => :environment do
      path = ENV['LAMBY_SSM_PARAMS_PATH']
      raise ArgumentError, 'The LAMBY_SSM_PARAMS_PATH env is required.' unless path
      Lamby::SsmParameterStore.dotenv(path)
    end

  end

end
