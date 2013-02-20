$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'catcher'
require 'mocha/api'
require 'simplecov'
require_relative 'support/dummy_class'

SimpleCov.start if ENV['COVERAGE']


MockClient = Class.new
Catcher::CacheStore.instance.client = MockClient.new

RSpec.configure do |config|
  config.mock_framework = :mocha
  config.order = 'random'
end
