ENV['RUBYOPT'] = '-W:no-deprecated -W:no-experimental'
require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:testv2) do |t|
  t.libs << "test/testRackv2"
  t.libs << "lib"
  t.test_files = begin
    if ENV['TEST_FILE']
      [ENV['TEST_FILE']]
    else
      FileList["test/testRackv2/**/*_test.rb", "test/*_test.rb"]
    end
  end
  t.verbose = false
  t.warning = false
end

Rake::TestTask.new(:testv3) do |t|
  t.libs << "test/testRackv3"
  t.libs << "lib"
  t.test_files = begin
    if ENV['TEST_FILE']
      [ENV['TEST_FILE']]
    else
      FileList["test/testRackv3/**/*_test.rb", "test/*_test.rb"]
    end
  end
  t.verbose = false
  t.warning = false
end

Rake::TestTask.new(:test_deflate) do |t|
  t.libs << "test/testRackv2"
  t.libs << "lib"
  t.test_files = FileList["test/rack_deflate_test.rb"]
  t.verbose = false
  t.warning = false
end


task :default => [:testv2, :testv3, :test_deflate]
