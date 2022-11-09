module TestHelpers
  module DummyAppHelpers

    extend ActiveSupport::Concern

    private

    def dummy_app
      ::Dummy::Application
    end

    def dummy_root
      dummy_app.root
    end

    def dummy_config
      dummy_app.config
    end

    def dummy_app_image
      File.read dummy_root.join('app/images/1.png')
    end

    def dummy_app_image_public
      File.read dummy_root.join('public/1-public.png')
    end

  end
end
