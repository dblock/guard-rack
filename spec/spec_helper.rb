if ENV['COVERAGE'] || ENV['CI']
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatters = [SimpleCov::Formatter::HTMLFormatter,
                          Coveralls::SimpleCov::Formatter]

  SimpleCov.start do
    add_filter '/spec/'
    add_filter '/vendor/'
    minimum_coverage(97.52)
  end
end

require 'mocha/api'
require 'guard/compat/test/helper'

RSpec.configure do |c|
  c.mock_with :mocha
  c.raise_errors_for_deprecations!
end
