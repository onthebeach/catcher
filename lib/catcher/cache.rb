module Catcher
  class Cache

    def initialize(api)
      @api = api
    end

    def resource
      cached_resource || cache_resource || {}
    end

    def cached_resource
      CacheStore.instance.get(@api.cache_key)
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

    def parsed_api_response
      @parsed_api_response ||= Service.factory(api_resource).parsed_api_response
    end

    def root_key
      @api.root_key
    end
    alias :root_key? :root_key

    def cache_key
      @api.cache_key
    end

    def api_resource
      @api.resource
    end

    def cache(response)
      CacheStore.instance.set(cache_key, response)
    end
  end
end
