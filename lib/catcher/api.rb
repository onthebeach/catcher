module Catcher
  class API
    attr_reader :options

    def self.fetch_for(options={})
      new(options).with_indifferent_access
    end

    def initialize(options)
      @options = options
    end

    def data
      @data ||= Cache.new(self).resource
    end

    def with_indifferent_access
      data.with_indifferent_access
    end

    def resource
      # required, must be a valid url
      # "http://some.api/endpoint"
    end

    def cache_key
      # optional, leave blank to always skip cache
      # "namespace-locale-id"
    end

    def root_key
      # optional, include to remove the root key from response
      # :hotel
    end

    def expires_in
      # optional, include to set expires_in per endpoint
      # 500
    end
  end
end
