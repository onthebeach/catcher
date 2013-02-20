require 'spec_helper'

describe Encoder do

  let(:encoder) { Encoder.encode(string)  }
  let(:string) { 'test' }

  it 'returns a string' do
    expect(encoder).to eq string
  end
end
