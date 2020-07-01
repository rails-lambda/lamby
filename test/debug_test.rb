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
      @old_env = ENV
      ENV['LAMBY_DEBUG'] = '1'
    end

    after { ENV.replace(@old_env) }

    describe 'when RACK_ENV == development' do
      before { ENV['RACK_ENV'] = 'development' }

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
      before { ENV['RAILS_ENV'] = 'development' }

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
