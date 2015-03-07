$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'mocha/api'
require 'guard/compat/test/helper'

RSpec.configure do |c|
  c.mock_with :mocha
  c.raise_errors_for_deprecations!
end
