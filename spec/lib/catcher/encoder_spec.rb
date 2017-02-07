#-*- coding: utf-8 -*-
require 'spec_helper'

describe Encoder do
  let(:encoder) { Encoder.encode(string)  }
  let(:string) { "äåéöÄÅÉÖabcdef123098%^&*()%$£\"!¿./?_`¬¿ ¿\u003c\u003e…".force_encoding('UTF-8')  }
  let(:expected) { 'äåéöÄÅÉÖabcdef123098%^&*()%$£"!¿./?_`¬¿ ¿<>…'  }

  it 'returns a string' do
    expect(encoder).to eq expected
  end

  context 'encoded string' do
    let(:string) { "\xC3".force_encoding('ISO-8859-1') }
    let(:expected) { 'Ã' }

    it 'fixes encoded strings into characters' do
      expect(encoder).to eq expected
    end
  end
end
