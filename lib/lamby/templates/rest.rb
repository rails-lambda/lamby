$LAMBY_INSTALLER_NAME = 'rest'
load 'lamby/templates/shared.rb'

say '==> Running Lamby API Gateway (REST API) installer...'

say 'Copying files...'
copy_file tpl_file('app.rb'), app_file('app.rb')
copy_file tpl_file('template.yaml'), app_file('template.yaml')
gsub_file app_file('template.yaml'), /APPNAMEHERE/, appname
copy_file tpl_file('Dockerfile'), app_file('Dockerfile')
copy_file tpl_file('Dockerfile-build'), app_file('Dockerfile-build')
copy_file tpl_file('docker-compose.yml'), app_file('docker-compose.yml')

say 'Adding to .gitignore...'
FileUtils.touch app_file('.gitignore')
append_to_file app_file('.gitignore'), <<~GITIGNORE
  # Lamby
  /.aws-sam
  /.lamby
GITIGNORE

say 'Creating ./bin files for build and deploy...'
copy_file tpl_file('_build'), app_file('bin/_build')
gsub_file app_file('bin/_build'), /APPNAMEHERE/, appname.downcase
chmod app_file('bin/_build'), 0755
copy_file tpl_file('deploy'), app_file('bin/deploy')
chmod app_file('bin/deploy'), 0755
copy_file tpl_file('_deploy'), app_file('bin/_deploy')
gsub_file app_file('bin/_deploy'), /APPNAMEHERE/, appname.downcase
chmod app_file('bin/_deploy'), 0755
gsub_file app_file('bin/deploy'), /APPNAMEHERE/, appname.downcase

say 'Welcome to AWS Lambda and Rails 🎉', :green
