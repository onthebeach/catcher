require 'spec_helper'

describe Catcher do

  let(:cache_store) { stub }
  before do
    Catcher::CacheStore.stubs(:instance).returns(cache_store)
    Catcher::Service.set_implementation! Catcher::Service::EM::Http
  end

  describe "Integration" do

    let(:hash) { { :id => 1 } }
    let(:id) { 1 }
    let(:locale) { :en }
    let(:options) { { :id => id, :locale => locale } }
    let(:cache_key) { 'example-en-1' }
    let(:resource) { "http://example.com/en/1" }
    let(:request) { stub(response:'{"example":{"id":1}}') }

    context "API" do
      before do
        EventMachine::HttpRequest.stubs(:new).returns(request)
        request.stubs(:get).returns(request)
        cache_store.expects(:get).with(cache_key).returns(false)
        cache_store.expects(:set).with(cache_key, hash, 500)
      end

      it "works" do
        EM.synchrony do
          expect(CacheApi.fetch_for(options)).to eq hash.with_indifferent_access
          EventMachine.stop
        end
      end
    end

    context "Memcached" do
      before do
        cache_store.expects(:get).with(cache_key).returns(hash)
      end

      it "works" do
        EM.synchrony do
          expect(CacheApi.fetch_for(options)).to eq hash.with_indifferent_access
          EventMachine.stop
        end
      end
    end

    context "No cache" do
      before do
        EventMachine::HttpRequest.stubs(:new).returns(request)
        request.stubs(:get).returns(request)
        cache_store.expects(:get).never
        cache_store.expects(:set).never
      end

      it "works" do
        EM.synchrony do
          expect(NoCacheApi.fetch_for(options)).to eq hash.with_indifferent_access
          EventMachine.stop
        end
      end
    end
  end
end
