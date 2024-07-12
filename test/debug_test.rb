require 'test_helper'

class DebugTest < LambySpec
  describe '#on?' do
    let(:event) do
      TestHelpers::Events::HttpV2.create(
        'queryStringParameters' => {
          'debug' => debug_param
        }
      )
    end

    before do
      @old_rack_env = ENV['RACK_ENV']
      @old_rails_env = ENV['RAILS_ENV']
      ENV['RACK_ENV'] = rack_env
      ENV['RAILS_ENV'] = rails_env
    end

    after do
      ENV['RACK_ENV'] = @old_rack_env
      ENV['RAILS_ENV'] = @old_rails_env
    end

    describe 'when RACK_ENV == development' do
      let(:rack_env) { 'development' }
      let(:rails_env) { nil }

      describe 'when the debug param is 1' do
        let(:debug_param) { '1' }

        it 'returns true' do
          expect(Lamby::Debug.on?(event)).must_equal true
        end
      end

      describe 'when the debug param is nil' do
        let(:debug_param) { nil }

        it 'returns false' do
          expect(Lamby::Debug.on?(event)).must_equal false
        end
      end
    end

    describe 'when RAILS_ENV == development' do
      let(:rack_env) { 'production' }
      let(:rails_env) { 'development' }

      describe 'when the debug param is 1' do
        let(:debug_param) { '1' }

        it 'returns true' do
          expect(Lamby::Debug.on?(event)).must_equal true
        end
      end

      describe 'when the debug param is nil' do
        let(:debug_param) { nil }

        it 'returns false' do
          expect(Lamby::Debug.on?(event)).must_equal false
        end
      end
    end
  end
end
