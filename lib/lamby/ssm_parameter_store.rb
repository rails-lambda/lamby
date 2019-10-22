require 'aws-sdk-ssm'

module Lamby
  class SsmParameterStore

    MAX_RESULTS = 10

    Param = Struct.new :name, :env, :value

    attr_reader :path, :params

    class << self

      def dotenv(path)
        new(path).get!.to_dotenv
      end

      def get!(path)
        parts = path.from(1).split('/')
        env = parts.pop
        path = "/#{parts.join('/')}"
        new(path).get!.params.detect do |p|
          p.env == env
        end.try(:value)
      end

    end

    def initialize(path, options = {})
      @path = path
      @params = []
      @options = options
    end

    def to_env(overwrite: true)
      params.each do |param|
        overwrite ? ENV[param.env] = param.value : ENV[param.env] ||= param.value
      end
    end

    def to_dotenv
      File.open(dotenv_file, 'w') { |f| f.write(dotenv_contents) }
    end

    def get!
      get_all!
      get_history! if label.present?
      self
    end

    def label
      ENV['LAMBY_SSM_PARAMS_LABEL'] || @options[:label]
    end

    def client
      @client ||= begin
        options = @options[:client_options] || {}
        Aws::SSM::Client.new(options)
      end
    end


    private

    def dotenv_file
      @options[:dotenv_file] || ENV['LAMBY_SSM_PARAMS_FILE'] || Rails.root.join(".env.#{Rails.env}")
    end

    def dotenv_contents
      params.each_with_object('') do |param, contents|
        line = "export #{param.env}=#{param.value}\n"
        contents << line
      end
    end

    # Path

    def get_all!
      return params if @got_all
      get_parse_all
      while @all_response.next_token do get_parse_all end
      @got_all = true
      params
    end

    def get_parse_all
      get_all
      parse_all
    end

    def get_all
      @all_response = client.get_parameters_by_path(get_all_options)
    end

    def get_all_options
      { path: path,
        recursive: true,
        with_decryption: true,
        max_results: MAX_RESULTS
      }.tap { |options|
        token = @all_response.try(:next_token)
        options[:next_token] = token if token
      }
    end

    def parse_all
      @all_response.parameters.each do |p|
        env = p.name.split('/').last
        params << Param.new(p.name, env, p.value)
      end
    end

    # History

    def get_history!
      return params if @got_history
      params.each do |param|
        name = param.name
        get_parse_history(name)
        while @hist_response.next_token do get_parse_history(name) end
      end
      @got_history = true
      params
    end

    def get_parse_history(name)
      get_history(name)
      parse_history(name)
    end

    def get_history(name)
      @hist_response = client.get_parameter_history(get_history_options(name))
    end

    def get_history_options(name)
      { name: name,
        with_decryption: true,
        max_results: MAX_RESULTS
      }.tap { |options|
        token = @hist_response.try(:next_token)
        options[:next_token] = token if token
      }
    end

    def parse_history(name)
      @hist_response.parameters.each do |p|
        next unless p.labels.include? label
        param = params.detect { |param| param.name == name }
        param.value = p.value
      end
    end

  end
end
