require 'spec_helper'
require 'catcher/em'

module Catcher

  describe Data do

    let(:cache_store) { stub }
    before do
      Catcher::CacheStore.stubs(:instance).returns(cache_store)
    end

    describe Service::EM::Http do
      let(:url) { stub }
      let(:service) { Service::EM::Http.new(url) }
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
          service.parsed_api_response.should eq parsed
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

        before do
          service.stubs(:request).returns(request)
          request.expects(:response).returns(response)
          Encoder.expects(:encode).with(response).returns(encoded)
        end

        it "encodes the response" do
          expect(service.response).to eq encoded
        end
      end

      describe "#request" do
        let(:response) { stub }
        let(:request) { stub }

        before do
          EventMachine::HttpRequest.expects(:new).with(url, service.options).returns(request)
          request.expects(:get).returns(response)
        end

        it "makes a request" do
          expect(service.request).to eq response
        end
      end
    end
  end
end
