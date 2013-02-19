# Catcher [![Build Status](https://travis-ci.org/onthebeach/catcher.png?branch=master)](http://travis-ci.org/onthebeach/catcher) [![Code Climate](https://codeclimate.com/github/onthebeach/catcher.png)](https://codeclimate.com/github/onthebeach/catcher)

Catcher wraps JSON API calls, and stores the parsed hash in Memcached.
Subsequent calls to the same API will either be returned directly from cache, or drop through to the API.

## Recommended implementation

Create a Data Access Object that inherits from Catcher::API, implementing two required methods `cache_key` and `resource`, along with any helper methods needed.
In this example `query` is used to build the resource url and is also used in the cache key.

    class GoogleDAO < Catcher::API
      def cache_key
        "google-search-#{query}"
      end

      def resource
        "https://www.googleapis.com/customsearch/v1?q=#{query}"
      end

      def query
        options.fetch(:query)
      end
    end

The resource can now be called using `.fetch_for`. This method takes a hash of arbitrary options.

    response = GoogleDAO.fetch_for({query: 'dao'})
    => [{ "rank": "1", "url": "http://example.com/1" }, { "rank": "1", "url": "http://example.com/1" }]
    response.first.fetch(:rank)
    => "1"
    response.last.fetch('url')
    => "http://example.com/2"

The `API` class currently expects one of the following response formats from the external API:

* a hash `{ things: 'stuff' }`
* an array of hashes `[ { things: 'stuff' } ]`
* a hash with root key `{ things: { stuff: 'things' } }`
* an array of hashes with root key `{ things: [{ stuff: 'things' }] }`

If a nil response is received, an error will be raised.

Options passed to `fetch_for` will be available by calling `#options`.
This value will default to an empty hash.

Use another class to wrap the call to the DAO:

    class Google

      def self.search(query)
        GoogleDAO.fetch_for({query: query}).map { |result| new result }
      end

      def initialize(data)
        @data = data
      end

      def rank
        @data.fetch(:rank).to_i
      end

      def url
        URI.parse @data.fetch(:url)
      end
    end

The resource can now be called using `Google.search(query)`:

    results = Google.search('dao')
    => [#<Google @data={rank:"1", url:"http://example.com/1"}>, #<Google @data={rank:"2", url:"http://example.com/2"}>]
    results.first.rank
    => 1
    results.last.url
    => #<URI::HTTP URL:http://example.com/2>

## Installation

  Install via bundler, or checkout out the repo and run `bundle && rake install`

### Rails

    # Gemfile
    gem 'catcher', github: 'onthebeach/catcher'

    # config/initializers/catcher.rb
    memcached_client = Dalli::Client.new('localhost:11211', expires_in: 14400, namespace: 'catcher-your-app')
    Catcher::CacheStore.client = memcached_client

### Goliath

    # Gemfile
    gem 'catcher', github: 'onthebeach/catcher', require: 'catcher/em'

    # config/your_api.rb
    memcached_client = EM::Synchrony::ConnectionPool.new(size: 20) do
      Dalli::Client.new('localhost:11211', async: true, expires_in: 14400, namespace: 'catcher-your-app')
    end

    Catcher::CacheStore.client = memcached_client

### Copyright

Copyright (c) 2013 OnTheBeach Ltd. See LICENSE.txt for
further details.

