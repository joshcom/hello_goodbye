# -*- encoding: utf-8 -*-
require File.expand_path('../lib/hello_goodbye/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Joshua Murray"]
  gem.email         = ["joshua.murray@gmail.com"]
  gem.description   = %q{A daemon manager with a TCP interface built on top of EventMachine.}
  gem.summary       = %q{A daemon manager with a TCP interface built on top of EventMachine.}
  gem.homepage      = "https://github.com/joshcom/hello_goodbye"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "hello_goodbye"
  gem.require_paths = ["lib"]
  gem.version       = HelloGoodbye::VERSION

  gem.add_dependency "eventmachine", "0.12.10"
  gem.add_dependency "json", "1.5.3"
  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "shoulda", ">= 0"
  gem.add_development_dependency "rspec", "2.6.0"
end
