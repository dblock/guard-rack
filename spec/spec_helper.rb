require 'mocha/api'
require 'guard/compat/test/helper'

RSpec.configure do |c|
  c.mock_with :mocha
  c.raise_errors_for_deprecations!
end
