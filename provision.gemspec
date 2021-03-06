# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'provision/version'

Gem::Specification.new do |gem|
  gem.name          = "provision"
  gem.version       = Provision::VERSION
  gem.authors       = ["Chen Fisher"]
  gem.email         = ["chen.fisher@gmail.com"]
  gem.description   = %q{Lets one hook a provision for a method}
  gem.summary       = %q{When a method is provisioned, any call to that method is passed through a provision filter that can stop the method execution and perform some actions}
  gem.homepage      = "https://github.com/chenfisher/provision"

  gem.add_development_dependency "rspec"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
