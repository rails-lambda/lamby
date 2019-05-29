$LAMBY_INSTALLER_NAME = 'api_gateway'
load 'lamby/templates/shared.rb'

say '==> Running Lamby API Gateway installer...'

say 'Copying files...'
copy_file tpl_file('app.rb'), app_file('app.rb')
copy_file tpl_file('template.yaml'), app_file('template.yaml')
gsub_file app_file('template.yaml'), /APPNAMEHERE/, appname

say 'Adding to .gitignore...'
FileUtils.touch app_file('.gitignore')
append_to_file app_file('.gitignore'), <<-GITIGNORE.strip_heredoc
  # Lamby
  /.aws-sam
GITIGNORE

say 'Creating ./bin files for build and deploy...'
copy_file shr_file('build'), app_file('bin/build')
chmod app_file('bin/build'), 0755
copy_file shr_file('deploy'), app_file('bin/deploy')
chmod app_file('bin/deploy'), 0755
gsub_file app_file('bin/deploy'), /APPNAMEHERE/, appname.downcase

say 'Welcome to AWS Lambda and Rails 🎉', :green
