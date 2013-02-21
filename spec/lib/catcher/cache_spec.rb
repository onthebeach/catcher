require 'spec_helper'

module Catcher
  describe Cache do
    let(:cache_store) { stub }
    let(:service_class) { stub }

    before do
      CacheStore.stubs(:instance).returns(cache_store)
      Catcher::Service.set_implementation! service_class
    end

    describe Cache do
      let(:id) { 1 }
      let(:locale) { :en }
      let(:options) { { id:id, locale:locale}  }
      let(:api) { CacheApi.new(options) }
      let(:cache) { Cache.new(api) }

      describe "#new" do
        it "takes an api" do
          cache
        end
      end

      describe "example" do
        context "cached example" do
          let(:cached_resource) { stub }

          before do
            cache.stubs(:cached_resource).returns(cached_resource)
          end

          it "returns the cached example" do
            expect(cache.resource).to eq cached_resource
          end
        end

        context "no cached example" do
          let(:cache_resource) { stub }

          before do
            cache.stubs(:cached_resource).returns(nil)
            cache.stubs(:cache_resource).returns(cache_resource)
          end

          it "caches the example" do
            expect(cache.resource).to eq cache_resource
          end
        end
      end

      describe "#cached_resource" do
        let(:result) { stub }

        context "cacheable" do
          before do
            cache_store.expects(:get).with('example-en-1').returns(result)
          end

          it "searches cache" do
            expect(cache.cached_resource).to eq result
          end
        end

        context "uncacheable" do
          let(:api) { NoCacheApi.new(options) }
          before do
            cache_store.expects(:get).never
          end

          it "does not search cache" do
            expect(cache.cached_resource).to be_nil
          end
        end
      end

      describe "#cache_resource" do
        let(:response) { stub }

        context "cacheable" do
          before do
            cache.expects(:keyed_response).returns(response)
            cache_store.expects(:set).with('example-en-1', response, 500)
          end

          it "searches cache" do
            expect(cache.cache_resource).to eq response
          end
        end

        context "uncacheable" do
          let(:api) { NoCacheApi.new(options) }

          before do
            cache.expects(:keyed_response).returns(response)
            cache_store.expects(:set).never
          end

          it "searches cache" do
            expect(cache.cache_resource).to eq response
          end
        end
      end

      describe "#keyed_response" do
        let(:example) { stub }
        let(:response) { {:example => example} }
        let(:resource) { 'http://example.com/en/1' }
        let(:service) { stub }

        before do
          service_class.expects(:new).with(resource).returns(service)
          service.expects(:parsed_api_response).returns(response)
        end

        it "searches cache" do
          expect(cache.keyed_response).to eq example
        end
      end
    end
  end
end
