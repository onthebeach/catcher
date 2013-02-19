require 'spec_helper'

describe Catcher do

  class DummyClass < Catcher::API
    def id
      @id ||= @options.fetch(:id)
    end

    def locale
      @locale ||= @options.fetch(:locale)
    end

    def cache_key
      "example-#{locale}-#{id}"
    end

    def root_key
      :example
    end

    def domain
      'example.com'
    end

    def resource
      "http://#{domain}/#{locale}/#{id}"
    end
  end

  let(:cache_store) { stub }
  before do
    Catcher::CacheStore.stubs(:instance).returns(cache_store)
    Catcher::Service.set_implementation! Catcher::Service::EM::Http
  end

  describe "Integration" do

    let(:hash) { { id: 1 } }
    let(:id) { 1 }
    let(:locale) { :en }
    let(:options) { {id:id, locale:locale} }
    let(:cache_key) { 'example-en-1' }
    let(:resource) { "http://example.com/en/1" }
    let(:request) { stub(response:'{"example":{"id":1}}') }

    context "API" do
      before do
        EventMachine::HttpRequest.stubs(:new).returns(request)
        request.stubs(:get).returns(request)
        cache_store.expects(:get).with(cache_key).returns(false)
        cache_store.expects(:set).with(cache_key, hash)
      end

      it "works" do
        EM.synchrony do
          expect(DummyClass.fetch_for(options)).to eq hash.with_indifferent_access
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
          expect(DummyClass.fetch_for(options)).to eq hash.with_indifferent_access
          EventMachine.stop
        end
      end
    end
  end
end
