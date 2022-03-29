class Something
  include Contracts

  Contract None => :something_is_done
  def call
    :something_is_done
  end
end

class Example
  include Contracts

  Contract Something => :something_is_done
  def do_something(something)
    something.call
  end

  Contract String => Something
  def returns_something
    Something.new
  end
end

RSpec.describe Example do
  let(:something) { instance_double(Something, call: :something_is_done) }

  context "without Contracts::RSpec::Mocks included" do
    it "violates contract" do
      expect { subject.do_something(something) }
        .to raise_error(ContractError, /Expected: Something/)
    end
  end

  context "with Contracts::RSpec::Mocks included" do
    include Contracts::RSpec::Mocks

    it "succeeds contract" do
      expect(subject.do_something(something)).to eq(:something_is_done)
    end

    it "violates return value contract" do
      something = instance_double(Something)
      allow(Something).to receive(:new).and_return(something)

      Example.new.returns_something
    end
  end
end
