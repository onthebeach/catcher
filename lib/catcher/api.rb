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

    # implement the following methods in sub classes
    def cache_key
      # eg "namespace-locale-id"
    end

    def root_key
      # eg :hotel, if the response includes the root key in json
    end

    def resource
      # "http://some.api/endpoint"
    end
  end
end
