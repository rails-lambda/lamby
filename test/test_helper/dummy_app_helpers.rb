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

    def dummy_handler
      dummy_root.join 'app.rb'
    end

    def dummy_compose
      dummy_root.join 'docker-compose.yml'
    end

    def dummy_docker
      dummy_root.join 'Dockerfile'
    end

    def dummy_docker_build
      dummy_root.join 'Dockerfile-build'
    end

    def dummy_template
      dummy_root.join 'template.yaml'
    end

    def dummy_bin_build
      dummy_root.join 'bin/_build'
    end

    def dummy_bin_deploy
      dummy_root.join 'bin/deploy'
    end

    def dummy_bin__deploy
      dummy_root.join 'bin/_deploy'
    end

    def dummy_gitignore
      dummy_root.join '.gitignore'
    end

    def dummy_app_image
      File.read dummy_root.join('app/images/1.png')
    end

    def dummy_app_image_public
      File.read dummy_root.join('public/1-public.png')
    end

    def delete_dummy_files
      FileUtils.rm_rf dummy_gitignore
      FileUtils.rm_rf dummy_handler
      FileUtils.rm_rf dummy_compose
      FileUtils.rm_rf dummy_docker
      FileUtils.rm_rf dummy_docker_build
      FileUtils.rm_rf dummy_template
      FileUtils.rm_rf dummy_bin_build
      FileUtils.rm_rf dummy_bin_deploy
      FileUtils.rm_rf dummy_bin__deploy
    end

    # Runners

    def run_task(task_name, stream=:stdout)
      capture(stream) do
        Dir.chdir(dummy_root) do
          Kernel.system "#{run_cmd} #{task_name}"
        end
      end
    end

    def run_cmd
      'rake'
    end

  end
end
