require 'test_helper'

class IntegrationTest < LambySpec

  it 'lamby:install:api_gateway' do
    out = run_task 'lamby:install:api_gateway'
    expect(out).must_include 'Running Lamby API Gateway installer'
    # Handler
    assert File.exists?(dummy_handler)
    expect(File.read(dummy_handler)).must_include <<-RUBY.strip_heredoc
      def handler(event:, context:)
        Lamby.handler $app, event, context, rack: :api
      end
    RUBY
    # Template
    assert File.exists?(dummy_template)
    expect(File.read(dummy_template)).must_include 'Transform: AWS::Serverless-2016-10-31'
    expect(File.read(dummy_template)).must_include 'Description: Dummy Lambda'
    # Bin Files
    assert File.exists?(dummy_bin_build)
    expect(File.read(dummy_bin_build)).must_include 'sam build --use-container'
    assert File.exists?(dummy_bin_deploy)
    expect(File.read(dummy_bin_deploy)).must_include 'sam package'
    expect(File.read(dummy_bin_deploy)).must_include '--s3-prefix "dummy-${RAILS_ENV}"'
    expect(File.read(dummy_bin_deploy)).must_include '--stack-name "dummy-${RAILS_ENV}-${AWS_DEFAULT_REGION}"'
  end

end
