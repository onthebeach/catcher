require 'spec_helper'
require 'dalli'

module Catcher

  describe CacheStore do
    let(:client) { MockClient.new }
    let(:key) { stub }
    let(:value) { stub }
    let(:ttl) { stub }


    before do
      CacheStore.client = client
    end

    describe ".client=" do
      before do
        CacheStore.client = 'test'
      end

      it "sets the client" do
        expect(CacheStore.instance.client).to eq 'test'
      end
    end

    describe "#load" do
      it "loads the configuration" do
        expect(CacheStore.instance.client).to eq client
      end
    end

    describe "#set" do
      before do
        client.expects(:set).with(key, value, ttl).returns(true)
      end

      it "delegates to the client" do
        expect(CacheStore.instance.set(key, value, ttl)).to be true
      end
    end

    describe "#get" do
      before do
        client.expects(:get).with(key).returns(value)
      end

      it "delegates to the client" do
        expect(CacheStore.instance.get(key)).to be value
      end
    end

    describe "#logger" do
      it "is an instance of Log4r" do
        expect(CacheStore.instance.logger).to be_a Log4r::Logger
      end
    end

    describe "#safely" do
      before do
        CacheStore.instance.expects(:get).raises(Dalli::DalliError)
      end

      it "rescues dalli errors" do
        expect(CacheStore.instance.safely { CacheStore.instance.get(key) }).to be_false
      end
    end
  end
end
