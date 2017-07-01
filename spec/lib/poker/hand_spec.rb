require 'test_helper'

RSpec.describe Poker::Hand do

  context "#initialize" do
    it "succeeds with a valid array of cards" do
      cards = %w(8C TS KC 9H 4S)
      hand = Poker::Hand.new(cards)
      expect(hand.cards).to eq(cards)
    end

    it "fails with an invalid set of cards" do
      too_few = %w(7D 2S 5D)
      too_many = %w(4S 7D 2S 5D 3S AC)
      duplicates = %w(2S 5D 3S AC 2S)

      {
        "Not enough cards to make a hand" => too_few,
        "Too many cards to make a hand" => too_many,
        "Cannot make a hand with duplicate cards" => duplicates
      }.each do |msg, cards|
        expect {
          Poker::Hand.new(cards)
        }.to raise_error(ArgumentError, msg)
      end
    end
  end
end
