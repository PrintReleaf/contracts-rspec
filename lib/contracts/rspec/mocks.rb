module Contracts
  module RSpec
    module Mocks
      def instance_double(klass, *args)
        super.tap do |double|
          allow(double).to receive(:is_a?).with(anything) do |other|
            klass <= other
          end
        end
      end
    end
  end
end
