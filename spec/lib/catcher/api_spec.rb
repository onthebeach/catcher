require 'spec_helper'

module Catcher

  describe API do

    let(:cache_store) { stub }
    before do
      Catcher::CacheStore.stubs(:instance).returns(cache_store)
    end

    describe API do
      let(:id) { 1 }
      let(:locale) { :en }
      let(:options) { { :id => id, :locale => locale}  }
      let(:api) { API.new(options) }
      let(:cache) { stub }

      describe ".fetch_for" do
        let(:hash) { stub }
        let(:api) { stub }

        before do
          API.expects(:new).with(options).returns(api)
          api.expects(:with_indifferent_access).returns(hash)
        end

        it "calls new, returns as hash" do
          expect(API.fetch_for(options)).to eq hash
        end
      end

      describe "#new" do

        before do
          Cache.stubs(:new).returns(cache)
          cache.stubs(:resource)
        end

        it "takes an id and a resource" do
          api
        end
      end

      describe "#options" do
        it "returns the options" do
          expect(api.options).to eq options
        end
      end

      describe "#api" do
        let(:cache) { stub }
        let(:id) { 1 }
        let(:hash) { {} }
        before do
          Cache.expects(:new).with(api).returns(cache)
          cache.expects(:resource).returns(hash)
        end

        context "data returned" do
          it "returns the api from Cache" do
            expect(api.data).to eq hash
          end
        end
      end

      describe "#with_indifferent_access" do
        let(:cache) { stub }
        let(:hash) { {'test' => 'test'} }
        let(:array) { [hash] }
        let(:id) { 1 }

        before do
          Cache.expects(:new).with(api).returns(cache)
        end

        context "hash returned" do
          before do
            cache.expects(:resource).returns(hash)
          end

          it "returns a hash with indifferent access" do
            expect(api.with_indifferent_access[:test]).to eq 'test'
          end
        end

        context "array returned" do
          before do
            cache.expects(:resource).returns(array)
          end

          it "returns an array of hashes with indifferent access" do
            expect(api.with_indifferent_access.first[:test]).to eq 'test'
          end
        end
      end
    end
  end
end
