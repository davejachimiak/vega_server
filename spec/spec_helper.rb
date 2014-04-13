require 'puma'
require './lib/vega_server'
require 'rspec/em'
require 'pry'
require 'async_helpers'
require 'bourne'

RSpec.configure do |config|
  config.mock_with :mocha
  config.fail_fast = true
end
