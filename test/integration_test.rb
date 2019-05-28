require 'test_helper'

class IntegrationTest < LambySpec

  it 'lamby:install:api_gateway' do
    out = run_task 'lamby:install:api_gateway'
    out.must_include 'Running Lamby API Gateway installer'
    # Handler
    assert File.exists?(dummy_handler)
    File.read(dummy_handler).must_include <<-RUBY.strip_heredoc
      def handler(event:, context:)
        Lamby.handler $app, event, context
      end
    RUBY
    # Template
    assert File.exists?(dummy_template)
    File.read(dummy_template).must_include 'Transform: AWS::Serverless-2016-10-31'
    File.read(dummy_template).must_include 'Description: Dummy Lambda'
    # Bin Files
    assert File.exists?(dummy_bin_build)
    File.read(dummy_bin_build).must_include 'sam build --use-container'
    assert File.exists?(dummy_bin_deploy)
    File.read(dummy_bin_deploy).must_include 'sam package'
    File.read(dummy_bin_deploy).must_include '--s3-prefix "dummy-${RAILS_ENV}"'
    File.read(dummy_bin_deploy).must_include '--stack-name "dummy-${RAILS_ENV}-${AWS_DEFAULT_REGION}"'
  end

end
