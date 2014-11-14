# -*- encoding: utf-8 -*-
require File.expand_path('../lib/guard/rack/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Daniel Doubrovkine']

  gem.email         = ['dblock@dblock.org']
  gem.description   = 'Automatically reloads your Rack based app on file change using Guard.'
  gem.homepage      = 'https://github.com/dblock/guard-rack'
  gem.summary       = gem.description
  gem.license       = 'MIT'

  gem.name          = 'guard-rack'
  gem.require_paths = ['lib']
  gem.files         = `git ls-files`.split("\n")
  gem.version       = Guard::RackVersion::VERSION

  gem.add_dependency 'guard', '~> 2.3'
  gem.add_dependency 'ffi'
  gem.add_dependency 'spoon'
  gem.add_dependency 'rb-inotify'
  gem.add_dependency 'libnotify'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'fakefs'
  gem.add_development_dependency 'mocha', '~> 1.0.0'
  gem.add_development_dependency 'rack'
end
