require 'spec_helper'

module Catcher

  describe Data do

    let(:cache_store) { stub }
    before do
      Catcher::CacheStore.stubs(:instance).returns(cache_store)
    end

    describe Service::Net::Http do
      let(:url)  { stub }
      let(:host) { stub }
      let(:uri)  { stub(host: host) }
      let(:service) { Service::Net::Http.new(url) }

      before do
        service.stubs(URI: uri)
      end

      describe "#new" do
        it "takes a url" do
          service
        end
      end

      describe "#parsed_api_response" do
        let(:parsed) { stub }
        let(:response) { stub }

        before do
          service.stubs(:response).returns(response)
          Yajl::Parser.expects(:parse).with(response, symbolize_keys: true).
            returns(parsed)
        end
        it "passes the respones to be parsed" do
          expect(service.parsed_api_response).to eq parsed
        end

        context 'the response is nil' do
          let(:response) { nil }
          let(:parsed) { nil }
          it 'explodes' do
            expect{ service.parsed_api_response }.to raise_error
          end
        end
      end

      describe "#response" do
        let(:encoded) { stub }
        let(:request) { stub }
        let(:response) { stub }
        let(:body){ stub }
        let(:http) { stub }

        before do
          service.stubs(:request).returns(request)
          service.stubs(:http).returns(http)
          http.expects(:request).returns(response)
          response.expects(:body).returns(body)
          Encoder.expects(:encode).with(body).returns(encoded)
        end

        it "encodes the response" do
          expect(service.response).to eq encoded
        end
      end

      describe "#request" do
        let(:response) { stub }
        let(:request) { stub }
        let(:http) { stub }

        before do
          ::Net::HTTP::Get.expects(:new).with(url).returns(request)
          request.expects(:[]=).with('Content-Type', 'application/json')

        end

        it "makes a request" do
          expect(service.request).to eq request
        end
      end
    end
  end
end
