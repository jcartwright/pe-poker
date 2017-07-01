require 'test_helper'

RSpec.describe Poker::Card do

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

  context "as comparable" do
    it "ace beats king" do
      ace = Poker::Card.new('AS')
      king = Poker::Card.new('KS')

      expect(ace).to be > king
      expect(king).to be < ace
    end

    it "king beats queen" do
      king = Poker::Card.new('KS')
      queen = Poker::Card.new('QS')

      expect(king).to be > queen
      expect(queen).to be < king
    end

    it "queen beats jack" do
      queen = Poker::Card.new('QS')
      jack = Poker::Card.new('JS')

      expect(queen).to be > jack
      expect(jack).to be < queen
    end

    it "jack beats 10" do
      jack = Poker::Card.new('JS')
      ten = Poker::Card.new('TS')

      expect(jack).to be > ten
      expect(ten).to be < jack
    end

    it "pip cards by value" do
      [['TS', '9S'], ['9S', '8S'], ['8S', '7S'], ['7S', '6S'],
       ['6S', '5S'], ['5S', '4S'], ['4S', '3S'], ['3S', '2S']].each do |cards|
        high, low = cards

        expect(high).to be > low
        expect(low).to be < high
      end
    end

    it "ignores suit in comparisons" do
      [['AS', 'AD'], ['KC', 'KH'], ['8D', '8H'], ['2D', '2C']].each do |cards|
        first, second = cards.map { |c| Poker::Card.new(c) }

        expect(first).to eq(second)
      end
    end
  end
end
