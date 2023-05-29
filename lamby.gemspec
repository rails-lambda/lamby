
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lamby/version'

Gem::Specification.new do |spec|
  spec.name          = "lamby"
  spec.version       = Lamby::VERSION
  spec.authors       = ["Ken Collins"]
  spec.email         = ["ken@metaskills.net"]
  spec.summary       = %q{Simple Rails & AWS Lambda Integration using Rack}
  spec.description   = %q{Simple Rails & AWS Lambda Integration using Rack and various utilities.}
  spec.homepage      = "https://github.com/rails-lambda/lamby"
  spec.license       = "MIT"
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'rack'
  spec.add_development_dependency 'aws-sdk-ssm'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-focus'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'webrick'
end
