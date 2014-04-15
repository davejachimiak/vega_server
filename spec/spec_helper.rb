require 'puma'
require './lib/vega_server'
require 'rspec/em'
require 'pry'
require 'async_helpers'
require 'bourne'
require 'multi_json'

RSpec.configure do |config|
  config.mock_with :mocha
  config.fail_fast = true
end
