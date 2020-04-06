require 'test_helper'

class SsmParameterStoreTest < LambySpec

  let(:klass) { Lamby::SsmParameterStore }
  let(:path)  { path_debug || '/config/staging/app/env' }
  let(:file)  { File.expand_path('../.env.staging', __FILE__) }

  after { clear! }

  describe '#to_env' do
    before do
      ENV['FOO'] = 'test'
    end

    it 'overwrites existing environment variables by default' do
      envs = klass.new path
      stub_params(envs)
      assert ENV.key?('FOO')
      refute ENV.key?('BAR')
      envs.to_env
      expect(ENV['FOO']).must_equal 'foo'
      expect(ENV['BAR']).must_equal 'bar'
    end

    it 'does not overwrite existing environment variables when overwrite flag set to false' do
      envs = klass.new path
      stub_params(envs)
      assert ENV.key?('FOO')
      refute ENV.key?('BAR')
      envs.to_env(overwrite: false)
      expect(ENV['FOO']).must_equal 'test'
      expect(ENV['BAR']).must_equal 'bar'
    end
  end

  it '#to_dotenv' do
    envs = klass.new path, dotenv_file: file
    stub_params(envs)
    envs.to_dotenv
    expect(File.read(file)).must_equal <<-EOF.strip_heredoc
      FOO=foo
      BAR=bar
    EOF
  end

  private

  def stub_params(envs)
    envs.stubs(:params).returns([
      param("#{path}/FOO", 'FOO', 'foo'),
      param("#{path}/BAR", 'BAR', 'bar')
    ])
  end

  def param(name, env, value)
    klass::Param.new(name, env, value)
  end

  def path_debug
    ENV['LAMBY_DEBUG_SSM_PATH'] if debug?
  end

  def debug?
    ENV['LAMBY_DEBUG_SSM'].present?
  end

  def clear!
    ENV.delete 'FOO'
    ENV.delete 'BAR'
    FileUtils.rm_rf(file)
  end

end
