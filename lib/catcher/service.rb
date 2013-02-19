module Catcher
  module Service

    def self.set_implementation!(implementation)
      @service_class = implementation
    end

    def self.factory(*params)
      @service_class.new(*params)
    end
  end
end
