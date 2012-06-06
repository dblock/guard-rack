source "http://rubygems.org"

gemspec

gem "guard", "~> 1.1"

group :development, :test do
  gem 'rake'
  gem "bundler",   "~> 1.0"
  gem "rspec",     "~> 2.6"
  gem "jeweler",   "~> 1.6"
  gem "guard-rspec"
  gem 'fakefs'
end

require 'rbconfig'

if RbConfig::CONFIG['target_os'] =~ /darwin/i
  gem 'rb-fsevent', '>= 0.3.9'
  gem 'growl', '~> 1.0.3'
end

if RbConfig::CONFIG['target_os'] =~ /linux/i
  gem 'rb-inotify', '>= 0.5.1'
  gem 'libnotify', '~> 0.1.3'
end

