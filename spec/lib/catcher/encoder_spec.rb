#-*- coding: utf-8 -*-

require 'spec_helper'
require 'json'

describe Encoder do
  subject { described_class.encode(string)  }

  let(:original) { { name: name }.to_json }
  let(:name) { 'äåéöÄÅÉÖabcdef123098%^&*()%$£"!¿./?_`¬¿ ¿' }
  let(:string) { original }

  it 'returns a string' do
    expect(subject).to be_an_instance_of(String)
  end

  context 'when passed a UTF8 string' do
    let(:string) { original.dup.force_encoding('UTF-8') }

    it 'returns given string' do
      expect(subject).to eq(original)
    end
  end

  context 'when passed an ASCII string' do
    let(:string) { original.dup.force_encoding('ASCII') }

    it 'returns a UTF8 string' do
      expect(subject).to eq(original)
    end
  end
end
