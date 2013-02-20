require 'yajl'

module Catcher
  module Service
    module EM
      class Http

        def initialize(url)
          @url = url
        end

        def parsed_api_response
          Yajl::Parser.parse(response, :symbolize_keys => true) or fail "Nil API response"
        end

        def response
          @repsonse ||= Encoder.encode(request.response)
        end

        def options
          {
            :connect_timeout => 20,
            :inactivity_timeout => 20
          }
        end

        def request
          EventMachine::HttpRequest.new(@url, options).get
        end
      end

      Service.set_implementation! EM::Http
    end
  end
end

