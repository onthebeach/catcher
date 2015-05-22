require 'yajl'

module Catcher
  module Service
    module EM
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
          @response ||= Encoder.encode(request.response)
        end

        def options
          {
            connect_timeout: api.open_timeout,
            inactivity_timeout: api.read_timeout
          }
        end

        def request
          EventMachine::HttpRequest.new(api.resource, options).
            get(head: api.headers)
        end
      end

      Service.set_implementation! EM::Http
    end
  end
end

