require 'test_helper'

RSpec.describe Poker::Hand do

  describe "#initialize" do
    it "succeeds with a valid array of cards" do
      card_codes = %w(8C TS KC 9H 4S)
      hand = Poker::Hand.new(card_codes)
      expect(hand.cards.map(&:card_code)).to eq(card_codes)
    end

    it "succeeds with a valid string of cards" do
      card_codes = "2S 8D 8C 4C TS"
      expect(Poker::Hand.new(card_codes))
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

  describe "#face_value" do
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

  describe "#high_card" do
    it "returns the card with the highest weight" do
      {
        Poker::Card.new('AS') => %w(KH 4H AS JS QS),
        Poker::Card.new('TS') => %w(2S 8D 8C 4C TS)
      }.each do |high_card, cards|
        hand = Poker::Hand.new(cards)
        expect(hand.high_card).to eq(high_card)
      end
    end
  end

  context "named hands" do
    describe "#royal_flush?" do
      it "returns true for a royal flush" do
        cards = %w(TS JS QS KS AS)
        hand = Poker::Hand.new(cards)
        expect(hand).to be_royal_flush
      end

      it "returns false if any card is out of suit" do
        cards = %w(TS JS QH KS AS)
        hand = Poker::Hand.new(cards)
        expect(hand).to_not be_royal_flush
      end

      it "returns false if any card is not a face card" do
        cards = %w(9S JS QH KS AS)
        hand = Poker::Hand.new(cards)
        expect(hand).to_not be_royal_flush
      end
    end

    describe "#straight_flush?" do
      it "returns true for a straight flush" do
        [
          %w(9D 8D 7D 6D 5D),
          %w(QH TH KH 9H JH)
        ].each do |cards|
          hand = Poker::Hand.new(cards)
          expect(hand).to be_straight_flush
        end
      end

      it "returns false if any card is not in suit" do
        cards = %w(9D 8D 7D 6C 5D)
        hand = Poker::Hand.new(cards)
        expect(hand).to_not be_straight_flush
      end

      it "returns false if any card is not sequential" do
        [
          %w(2C 3C 4C 5C 7C),
          %w(AS KS QS JS 3S)
        ].each do |cards|
          hand = Poker::Hand.new(cards)
          expect(hand).to_not be_straight_flush
        end
      end
    end

    describe "#four_of_a_kind?" do
      it "returns true if the hand contains all identical cards from each suit" do
        [
          %w(AS AC AH AD 2C),
          %w(8C 8D JH 8H 8S)
        ].each do |cards|
          hand = Poker::Hand.new(cards)
          expect(hand).to be_four_of_a_kind
        end
      end

      it "returns false if any suit is missing from the set of cards" do
        cards = %w(AS AC AH 8H 2H)
        hand = Poker::Hand.new(cards)
        expect(hand).to_not be_four_of_a_kind
      end
    end

    describe "#full_house?" do
      it "returns true if it contains three of a kind and a pair" do
        [
          %w(AC AD AS KH KS),
          %w(2C 2D 9H 9S 9D)
        ].each do |cards|
          hand = Poker::Hand.new(cards)
          expect(hand).to be_full_house
        end
      end

      it "returns false if it does not contain three of a kind and a pair" do
        cards = %w(AC AD JH KH KS)
        hand = Poker::Hand.new(cards)
        expect(hand).to_not be_full_house
      end
    end

    describe "#flush" do
      it "returns true if all cards are the same suit" do
        cards = %w(2D 9D 7D JD 3D)
        hand = Poker::Hand.new(cards)
        expect(hand).to be_flush
      end

      it "returns false if any card is out of suit" do
        cards = %w(2D 9D 7C JD 3D)
        hand = Poker::Hand.new(cards)
        expect(hand).to_not be_flush
      end
    end

    describe "#straight?" do
      it "returns true if all cards are sequential" do
        [
          %w(9D 8H 7C 6S 5D),
          %w(TS JD QH KC AS),
          %w(5D 9C 7H 6S 8S)
        ].each do |cards|
          hand = Poker::Hand.new(cards)
          expect(hand).to be_straight
        end
      end

      it "returns false is all cards are not sequential" do
        cards = %w(4D 9C 7H 6S 8S)
        hand = Poker::Hand.new(cards)
        expect(hand).to_not be_straight
      end
    end

    describe "#three_of_a_kind?" do
      it "returns true if contains 3 cards with the same face value" do
        cards = %w(AD AS AH TS 4C)
        hand = Poker::Hand.new(cards)
        expect(hand).to be_three_of_a_kind
      end

      it "returns false if does not contain 3 cards with the same face value" do
        cards = %w(AD AS TH TC JD)
        hand = Poker::Hand.new(cards)
        expect(hand).to_not be_three_of_a_kind
      end
    end

    describe "#two_pair" do
      it "returns true if contains 2 sets of cards with the same face value" do
        [
          %w(AD AS TH JC JD),
          %w(2H 3C 2D 3S 4H)
        ].each do |cards|
          hand = Poker::Hand.new(cards)
          expect(hand).to be_two_pair
        end
      end

      it "returns false if does not contain 2 sets of cards with the same face value" do
        cards = %w(AD AS TH JC 9D)
        hand = Poker::Hand.new(cards)
        expect(hand).to_not be_two_pair
      end
    end

    describe "#one_pair?" do
      it "returns true if contains at least one set of cards with the same face value" do
        [
          %w(AD AS TH JC 9D),
          %w(2H 3C 2D 3S 4H)
        ].each do |cards|
          hand = Poker::Hand.new(cards)
          expect(hand).to be_one_pair
        end
      end

      it "returns false if does not contain at least on set of cards with the same face value" do
        cards = %w(2C 3C 4C 5C 6C)
        hand = Poker::Hand.new(cards)
        expect(hand).to_not be_one_pair
      end
    end

  end

  context "as comparable" do
    it "royal flush beats straight flush"

    it "straight flush beats four of a kind"

    it "four of a kind beats full house"

    it "full house beats flush"

    it "flush beats straight"

    it "straight beats three of a kind"

    it "three of a kind beats two pairs"

    it "two pairs beats one pair"

    it "one pair beats high card"
  end
end
