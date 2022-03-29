module Contracts
  module RSpec
    module Mocks
      def instance_double(klass, *args)
        super.tap do |double|
          allow(double).to receive(:is_a?).with(klass).and_return(true)
          allow(double).to receive(:is_a?).with(ParamContractError).and_return(klass.is_a?(ParamContractError))
        end
      end
    end
  end
end
