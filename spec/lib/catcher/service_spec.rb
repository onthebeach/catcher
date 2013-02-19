require 'spec_helper'

module Catcher
  describe Service do
    describe "#set_implementation!" do
      let(:implementation) { stub }
      let(:service) { stub }
      let(:param) { stub }

      before do
        Service.set_implementation!(implementation)
        implementation.expects(:new).with(param).returns(service)
      end

      it 'sets the service class to use' do
        expect(Service.factory(param)).to eq service
      end
    end
  end
end
