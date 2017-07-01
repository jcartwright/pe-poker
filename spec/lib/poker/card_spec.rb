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

  describe "#card_code" do
    it "returns the original card_code, normalized" do
      expect(Poker::Card.new('8h').card_code).to eq('8H')
    end
  end

  describe "#value" do
    it "returns the first character of the card_code, normalized" do
      expect(Poker::Card.new('8h').value).to eq('8')
      expect(Poker::Card.new('TD').value).to eq('T')
      expect(Poker::Card.new('as').value).to eq('A')
    end
  end

  describe "#suit" do
    it "returns the last character of the card_code, normalized" do
      expect(Poker::Card.new('8h').suit).to eq('H')
      expect(Poker::Card.new('TD').suit).to eq('D')
      expect(Poker::Card.new('as').suit).to eq('S')
    end
  end

  describe "#weight" do
    it "returns a numeric value for the card's value" do
      expect(Poker::Card.new('8h').weight).to eq(8)
      expect(Poker::Card.new('TD').weight).to eq(10)
      expect(Poker::Card.new('as').weight).to eq(14)
    end
  end
end
