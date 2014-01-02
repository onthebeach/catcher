require 'yajl'
require 'net/http'

module Catcher
  module Service
    module Net
      class Http

        def initialize(url)
          @url = url
        end

        def parsed_api_response
          Yajl::Parser.parse(response, :symbolize_keys => true) or raise NilApiResponseError, "Nil API response"
        end

        def response
          @response ||= Encoder.encode(http.request(request).body)
        end

        def request
          ::Net::HTTP::Get.new(url).tap do |request|
            request['Content-Type'] = 'application/json'
          end
        end

        def port
          80
        end

        def uri
          URI(url)
        end

        private

        def http
          ::Net::HTTP.new(uri.host, port).tap do |http|
            http.open_timeout = 20
            http.read_timeout = 20
          end
        end

        attr_reader :url

      end

      Service.set_implementation! Catcher::Service::Net::Http
    end
  end
end
