$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'guard-rack'
require 'mocha/api'

RSpec.configure do |c|
  c.mock_with :mocha
  c.raise_errors_for_deprecations!
end
