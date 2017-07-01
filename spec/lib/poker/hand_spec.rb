require 'test_helper'

RSpec.describe Poker::Hand do

  context "#initialize" do
    it "succeeds with a valid array of cards" do
      card_codes = %w(8C TS KC 9H 4S)
      hand = Poker::Hand.new(card_codes)
      expect(hand.cards.map(&:card_code)).to eq(card_codes)
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

  context "#face_value" do
    it "returns the sum of the face values of all cards" do
      {
        36 => %w(5H 5C 6S 7S KD), #=> 5, 5, 6, 7, 13
        31 => %w(2C 3S 8S 8D TD), #=> 2, 3, 8, 8, 10
        54 => %w(KH 4H AS JS QS)  #=> 13, 4, 14, 11, 12
      }.each do |val, cards|
        expect(Poker::Hand.new(cards).face_value).to eq(val)
      end
    end
  end
end
