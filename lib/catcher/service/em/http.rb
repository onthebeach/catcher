require 'yajl'

module Catcher
  module Service
    module EM
      class Http

        def initialize(url, headers)
          @url = url
          @headers = headers
        end

        def parsed_api_response
          Yajl::Parser.parse(response, :symbolize_keys => true) or raise NilApiResponseError, "Nil API response"
        end

        def response
          @response ||= Encoder.encode(request.response)
        end

        def options
          {
            :connect_timeout => 20,
            :inactivity_timeout => 20
          }
        end

        def request
          EventMachine::HttpRequest.new(@url, options).get(:head => @headers)
        end
      end

      Service.set_implementation! EM::Http
    end
  end
end

