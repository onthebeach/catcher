$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'catcher'
require 'mocha/api'
require 'simplecov'

SimpleCov.start if ENV['COVERAGE']

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir['#{File.dirname(__FILE__)}/support/**/*.rb'].each {|f| require f}

MockClient = Class.new
Catcher::CacheStore.instance.client = MockClient.new

RSpec.configure do |config|
  config.mock_framework = :mocha
  config.order = 'random'
end
