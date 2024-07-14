ENV['RUBYOPT'] = '-W:no-deprecated -W:no-experimental'
require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:testv2) do |t|
  t.libs << "test/test_rack_v2"
  t.libs << "lib"
  t.test_files = begin
    if ENV['TEST_FILE']
      [ENV['TEST_FILE']]
    else
      FileList["test/test_rack_v2/**/*_test.rb", "test/*_test.rb"]
    end
  end
  t.verbose = false
  t.warning = false
end

Rake::TestTask.new(:testv3) do |t|
  t.libs << "test/test_rack_v3"
  t.libs << "lib"
  t.test_files = begin
    if ENV['TEST_FILE']
      [ENV['TEST_FILE']]
    else
      FileList["test/test_rack_v3/**/*_test.rb", "test/*_test.rb"]
    end
  end
  t.verbose = false
  t.warning = false
end

Rake::TestTask.new(:test_deflate) do |t|
  t.libs << "test/test_rack_v2"
  t.libs << "lib"
  t.test_files = FileList["test/rack_deflate_test.rb"]
  t.verbose = false
  t.warning = false
end


task :default => [:testv2, :testv3, :test_deflate]
