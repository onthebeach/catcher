module Catcher
  class Cache

    def initialize(api)
      @api = api
    end

    def resource
      cached_resource || cache_resource || {}
    end

    def cached_resource
      store.get(api.cache_key) if cacheable?
    end

    def cache_resource
      keyed_response.tap { |response| cache response }
    end

    def keyed_response
      if root_key?
        parsed_api_response[root_key]
      else
        parsed_api_response
      end
    end

    private
    attr_reader :api

    def parsed_api_response
      @parsed_api_response ||= Service.factory(api).parsed_api_response
    end

    def root_key
      api.root_key
    end
    alias :root_key? :root_key

    def cache_key
      api.cache_key
    end

    def cacheable?
      !!cache_key
    end

    def api_resource
      api.resource
    end

    def store
      CacheStore.instance
    end

    def ttl
      api.expires_in
    end

    def cache(response)
      store.set(cache_key, response, ttl) if cacheable?
    end

    def headers
      api.headers
    end
  end
end
