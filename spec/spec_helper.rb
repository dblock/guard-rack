$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'guard-rack'
require 'mocha_standalone'

RSpec.configure do |c|
  c.mock_with :mocha
end
