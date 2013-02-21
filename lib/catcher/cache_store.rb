require 'singleton'
require 'yaml'
require 'dalli'
require 'log4r'
require 'active_support/core_ext/hash/indifferent_access'

module Catcher
  class CacheStore
    include Singleton

    def self.client=(client)
      self.instance.client = client
    end

    def set(key, value, ttl)
      safely { @client.set(key, value, ttl) }
    end

    def get(key)
      safely { @client.get(key) }
    end

    def client
      @client
    end

    def client=(client)
      @client = client
    end

    def logger
      @logger ||= Log4r::Logger.new('catcher::cachestore')
    end

    def safely
      yield
    rescue Dalli::DalliError => boom
      logger.error "DalliError: #{boom}"
      false
    end
  end
end
