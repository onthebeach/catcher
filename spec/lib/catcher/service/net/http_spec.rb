require 'spec_helper'

module Catcher

  describe Data do

    let(:cache_store) { stub }
    before do
      Catcher::CacheStore.stubs(:instance).returns(cache_store)
    end

    describe Service::Net::Http do
      let(:resource)  { stub }
      let(:host) { stub }
      let(:uri)  { stub(:host => host) }
      let(:headers) { {} }
      let(:api) {
        stub('Api', resource: resource, headers: headers, open_timeout: 20, read_timeout: 20)
      }
      let(:service) {
        Service::Net::Http.new(api)
      }

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
          Yajl::Parser.expects(:parse).with(response, :symbolize_keys => true).
            returns(parsed)
        end
        it "passes the respones to be parsed" do
          expect(service.parsed_api_response).to eq parsed
        end

        context 'the response is nil' do
          let(:response) { nil }
          let(:parsed) { nil }
          it 'explodes' do
            expect{ service.parsed_api_response }.to raise_error Service::NilApiResponseError
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
        let(:request_uri) { '/example/abc' }

        before do
          uri.stubs(:request_uri).returns(request_uri)
          ::Net::HTTP::Get.expects(:new).with(uri.request_uri).returns(request)
          request.expects(:[]=).with('Content-Type', 'application/json')
        end

        context 'with headers' do
          let(:headers) { { 'Authorization' => 'XYZ' } }

          before do
            request.expects(:[]=).with('Authorization', 'XYZ')
          end

          it 'makes a request with headers included' do
            expect(service.request).to eq request
          end
        end

        it "makes a request" do
          expect(service.request).to eq request
        end
      end
    end
  end
end
