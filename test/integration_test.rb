require 'test_helper'

class IntegrationTest < LambySpec

  it 'lamby:install:http' do
    out = run_task 'lamby:install:http'
    expect(out).must_include 'API Gateway (HTTP API) installer'
    # Handler
    assert File.exists?(dummy_handler)
    expect(File.read(dummy_handler)).must_include <<~RUBY
      def handler(event:, context:)
        Lamby.handler $app, event, context
      end
    RUBY
    # Template
    assert File.exists?(dummy_template)
    expect(File.read(dummy_template)).must_include 'Transform: AWS::Serverless-2016-10-31'
    expect(File.read(dummy_template)).must_include 'Description: Dummy Lambda'
    # Bin Files
    assert File.exists?(dummy_bin_build)
    expect(File.read(dummy_bin_build)).must_include 'bundle install'
    assert File.exists?(dummy_bin_deploy)
    assert File.exists?(dummy_bin__deploy)
    expect(File.read(dummy_bin__deploy)).must_include 'sam package'
    expect(File.read(dummy_bin__deploy)).must_include '--image-repository "$IMAGE_REPOSITORY"'
    expect(File.read(dummy_bin__deploy)).must_include '--stack-name "dummy-${RAILS_ENV}"'
  end

  it 'lamby:install:rest' do
    out = run_task 'lamby:install:rest'
    expect(out).must_include 'API Gateway (REST API) installer'
    # Handler
    assert File.exists?(dummy_handler)
    expect(File.read(dummy_handler)).must_include <<~RUBY
      def handler(event:, context:)
        Lamby.handler $app, event, context
      end
    RUBY
    # Template
    assert File.exists?(dummy_template)
    expect(File.read(dummy_template)).must_include 'Transform: AWS::Serverless-2016-10-31'
    expect(File.read(dummy_template)).must_include 'Description: Dummy Lambda'
    # Bin Files
    assert File.exists?(dummy_bin_build)
    expect(File.read(dummy_bin_build)).must_include 'bundle install'
    assert File.exists?(dummy_bin_deploy)
    assert File.exists?(dummy_bin__deploy)
    expect(File.read(dummy_bin__deploy)).must_include 'sam package'
    expect(File.read(dummy_bin__deploy)).must_include '--image-repository "$IMAGE_REPOSITORY"'
    expect(File.read(dummy_bin__deploy)).must_include '--stack-name "dummy-${RAILS_ENV}"'
  end

end
