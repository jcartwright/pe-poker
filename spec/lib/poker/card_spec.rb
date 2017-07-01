require 'test_helper'

RSpec.describe Poker::Card do
  let(:valid_codes) {
    
  }

  context "#initialize" do
    it "succeeds with a valid card code" do
      expect(Poker::Card.new('2D'))
    end

    it "is case-insensitive" do
      expect(Poker::Card.new('ts'))
    end

    it "fails with an invalid value" do
      expect {
        Poker::Card.new("1D")
      }.to raise_error(ArgumentError, "1 is not a possible value")
    end

    it "fails with an invalid suit" do
      expect {
        Poker::Card.new("QX")
      }.to raise_error(ArgumentError, "X is not a possible suit")
    end
  end
end
