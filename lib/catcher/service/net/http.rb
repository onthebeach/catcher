require 'yajl'
require 'net/http'

module Catcher
  module Service
    module Net
      class Http
        attr_reader :api
        private :api

        def initialize(api)
          @api = api
        end

        def parsed_api_response
          Yajl::Parser.parse(response, :symbolize_keys => true) or raise NilApiResponseError, "Nil API response"
        end

        def response
          @response ||= Encoder.encode(http.request(request).body)
        end

        def request
          ::Net::HTTP::Get.new(uri.request_uri).tap do |request|
            request['Content-Type'] = 'application/json'
            api.headers.each { |k,v| request[k] = v }
          end
        end

        def uri
          URI(api.resource)
        end

        private

        def http
          ::Net::HTTP.new(uri.host, uri.port).tap do |http|
            http.use_ssl = uri.scheme == 'https'
            http.open_timeout = api.open_timeout
            http.read_timeout = api.read_timeout
          end
        end

        attr_reader :url

      end

      Service.set_implementation! Catcher::Service::Net::Http
    end
  end
end
