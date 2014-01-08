#-*- coding: utf-8 -*-
require 'spec_helper'

describe Encoder do

  let(:encoder) { Encoder.encode(ascii_string)  }
  let(:ascii_string) { 'äåéöÄÅÉÖabcdef123098%^&*()%$£"!¿./?_`¬¿ ¿'.force_encoding('ASCII')  }
  let(:utf8_string) { 'abcdef123098%^&*()%$"!./?_` ' }

  it 'returns a string' do
    expect(encoder).to eq utf8_string
  end
end
