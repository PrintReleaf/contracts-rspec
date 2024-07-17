class Organism
end

class Eukaryote < Organism
end

class Plant < Eukaryote
  include Contracts

  Contract None => :success
  def call
    :success
  end
end

class Tree < Plant
end

class Oak < Tree
end

class Example
  include Contracts

  Contract Plant => :success
  def test(instance)
    instance.call
  end
end

RSpec.describe Example do
  let(:organism) { instance_double(Organism) }
  let(:eukaryote) { instance_double(Eukaryote) }
  let(:plant) { instance_double(Plant, call: :success) }
  let(:tree) { instance_double(Tree, call: :success) }
  let(:oak) { instance_double(Oak, call: :success) }

  context "without Contracts::RSpec::Mocks included" do
    it "violates contract" do
      expect { subject.test(plant) }
        .to raise_error(ContractError, /Expected: Plant/)
    end
  end

  context "with Contracts::RSpec::Mocks included" do
    include Contracts::RSpec::Mocks

    it "succeeds contract" do
      expect(subject.test(plant)).to eq(:success)
    end

    context "when doubled class is a subclass of contract class" do
      it "succeeds contract" do
        expect(subject.test(tree)).to eq(:success)
      end
    end

    context "when doubled class is a descendant of contract class" do
      it "succeeds contract" do
        expect(subject.test(oak)).to eq(:success)
      end
    end

    context "when doubled class is the superclass of contract class" do
      it "violates contract" do
        expect { subject.test(eukaryote) }
          .to raise_error(ContractError, /Expected: Plant/)
      end
    end

    context "when doubled class is an ancestor of contract class" do
      it "violates contract" do
        expect { subject.test(organism) }
          .to raise_error(ContractError, /Expected: Plant/)
      end
    end
  end
end
