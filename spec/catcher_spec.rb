require 'spec_helper'

describe Catcher do

  let(:cache_store) { stub }
  before do
    Catcher::CacheStore.stubs(:instance).returns(cache_store)
    Catcher::Service.set_implementation! Catcher::Service::Net::Http
  end

  describe "Integration" do

    let(:hash) { { :id => 1 } }
    let(:id) { 1 }
    let(:locale) { :en }
    let(:options) { { :id => id, :locale => locale } }
    let(:cache_key) { 'example-en-1' }
    let(:resource) { "http://example.com/en/1" }
    let(:request) { stub(response: response, body: response) }
    let(:response) { '{"example":{"id":1}}' }

    let(:http) { stub }

    before do
      ::Net::HTTP.stubs(:new).returns(http)
      http.stubs(:use_ssl=).returns(http)
      http.stubs(:open_timeout=).returns(http)
      http.stubs(:read_timeout=).returns(http)
      http.stubs(:request).returns(request)
      request.stubs(:body).returns(response)
    end

    context "API" do
      before do
        cache_store.expects(:get).with(cache_key).returns(false)
        cache_store.expects(:set).with(cache_key, hash, 500)
      end

      it "works" do
        expect(CacheApi.fetch_for(options)).to eq hash.with_indifferent_access
      end
    end

    context "Memcached" do
      before do
        cache_store.expects(:get).with(cache_key).returns(hash)
      end

      it "works" do
        expect(CacheApi.fetch_for(options)).to eq hash.with_indifferent_access
      end
    end

    context "No cache" do
      before do
        cache_store.expects(:get).never
        cache_store.expects(:set).never
      end

      it "works" do
        expect(NoCacheApi.fetch_for(options)).to eq hash.with_indifferent_access
      end
    end
  end
end
