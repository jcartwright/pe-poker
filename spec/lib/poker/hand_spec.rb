require 'test_helper'

RSpec.describe Poker::Hand do

  describe "#initialize" do
    it "succeeds with a valid array of cards" do
      card_codes = %w(8C TS KC 9H 4S)
      hand = Poker::Hand.new(card_codes)
      expect(hand.cards.map(&:card_code)).to eq(["KC", "TS", "9H", "8C", "4S"])
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
        cards = %w(9S JS QS KS AS)
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

    describe "#high_card?" do
      it "returns true when high card is the only rank" do
        cards = %w(AS QH TD 3C 2S)
        hand = Poker::Hand.new(cards)
        expect(hand).to be_high_card
      end

      it "returns false when a better rank is possible" do
        [
          %w(AS AD QH 8C 6D),
          %w(QH JH TH 9H 8H)
        ].each do |cards|
          hand = Poker::Hand.new(cards)
          expect(hand).to_not be_high_card
        end
      end
    end

  end

  context "as comparable" do
    it "royal flush beats straight flush" do
      royal_flush = Poker::Hand.new(%w(TS JS QS KS AS))
      straight_flush = Poker::Hand.new(%w(QH TH KH 9H JH))

      expect(royal_flush).to be > straight_flush
    end

    it "royal flush has no tie breakers" do
      lh = Poker::Hand.new(%w(TS JS QS KS AS))
      rh = Poker::Hand.new(%w(TD JD QD KD AD))

      expect(lh).to eq(rh)
    end

    it "straight flush beats four of a kind" do
      straight_flush = Poker::Hand.new(%w(QH TH KH 9H JH))
      four_oak = Poker::Hand.new(%w(AS AC AH AD 2C))

      expect(straight_flush).to be > four_oak
    end

    it "straight flush with highest card(s) breaks the tie" do
      winner = Poker::Hand.new(%w(TD 9D 8D 7D 6D))
      loser  = Poker::Hand.new(%w(9H 8H 7H 6H 5H))

      expect(winner).to be > loser
    end

    it "four of a kind beats full house" do
      four_oak = Poker::Hand.new(%w(AS AC AH AD 2C))
      full_house = Poker::Hand.new(%w(AC AD AS KH KS))

      expect(four_oak).to be > full_house
    end

    it "four of a kind with the higher face value set breaks the tie" do
      winner = Poker::Hand.new(%w(AS AC AH AD 2C))
      loser  = Poker::Hand.new(%w(KS KC KH KD 2H))

      expect(winner).to be > loser

      winner = Poker::Hand.new(%w(3S 3C 3H 3D 2H))
      loser  = Poker::Hand.new(%w(2S 2C 2H 2D AC))

      expect(winner).to be > loser
    end

    it "full house beats flush" do
      full_house = Poker::Hand.new(%w(AC AD AS KH KS))
      flush = Poker::Hand.new(%w(2D 9D 7D JD 3D))

      expect(full_house).to be > flush
    end

    it "full house with the highest three of a kind breaks the tie" do
      winner = Poker::Hand.new(%w(AC AD AS QH QS))
      loser  = Poker::Hand.new(%w(KC KD KS JH JS))

      expect(winner).to be > loser

      winner = Poker::Hand.new(%w(4C 4D 4S 3H 3S))
      loser  = Poker::Hand.new(%w(2C 2D 2S AH AS))

      expect(winner).to be > loser
    end

    it "flush beats straight" do
      flush = Poker::Hand.new(%w(2D 9D 7D JD 3D))
      straight = Poker::Hand.new(%w(9D 8H 7C 6S 5D))

      expect(flush).to be > straight
    end

    it "flush with the highest card breaks the tie" do
      winner = Poker::Hand.new(%w(AD TD 9D 8D 6D))
      loser  = Poker::Hand.new(%w(QH TH 9H 8H 6H))

      expect(winner).to be > loser

      winner = Poker::Hand.new(%w(QD TD 9D 8D 7D))
      loser  = Poker::Hand.new(%w(QH TH 9H 8H 6H))

      expect(winner).to be > loser
    end

    it "straight beats three of a kind" do
      straight = Poker::Hand.new(%w(9D 8H 7C 6S 5D))
      three_oak = Poker::Hand.new(%w(2S 2D 2H 3C 4D))

      expect(straight).to be > three_oak
    end

    it "straight with the highest face value breaks the tie" do
      winner = Poker::Hand.new(%w(9D 8H 7C 6S 5D))
      loser  = Poker::Hand.new(%w(8D 7H 6C 5S 4D))

      expect(winner).to be > loser
    end

    it "three of a kind beats two pairs" do
      three_oak = Poker::Hand.new(%w(2S 2D 2H 3C 4D))
      two_pair = Poker::Hand.new(%w(5S 5D 8H 8C AS))

      expect(three_oak).to be > two_pair
    end

    it "three of a kind with the higher face value set breaks the tie" do
      winner = Poker::Hand.new(%w(3S 3D 3H 4C 6D))
      loser  = Poker::Hand.new(%w(2S 2D 2H 3C 4D))

      expect(winner).to be > loser
    end

    it "two pairs beats one pair" do
      two_pair = Poker::Hand.new(%w(2S 2D 8H 8C AS))
      one_pair = Poker::Hand.new(%w(2H 2C 8S 7C AD))

      expect(two_pair).to be > one_pair
    end

    it "two pairs with highest face value set wins" do
      winner = Poker::Hand.new(%w(5S 5D 3H 3C 2H))
      loser  = Poker::Hand.new(%w(4S 4D 2D 2C AD))

      expect(winner).to be > loser
    end

    it "two pairs with highest kicker card breaks the tie" do
      winner = Poker::Hand.new(%w(2S 2D 8H 8C AS))
      loser  = Poker::Hand.new(%w(2H 2C 8S 8D KD))

      expect(winner).to be > loser
    end

    it "one pair beats high card" do
      one_pair = Poker::Hand.new(%w(2S 2D 8D QC AH))
      high_card = Poker::Hand.new(%w(AS 3H 4C 5D TS))

      expect(one_pair).to be > high_card
    end

    it "one pair with the highest face value set wins" do
      winner = Poker::Hand.new(%w(4S 4D 8D QC AH))
      loser  = Poker::Hand.new(%w(3S 3D 8C QD AS))

      expect(winner).to be > loser
    end

    it "one pair with highest kicker card breaks the tie" do
      winner = Poker::Hand.new(%w(2S 2D 6H 7C AS))
      loser  = Poker::Hand.new(%w(2H 2C 6S 7H KD))

      expect(winner).to be > loser
    end

    it "high card breaks the tie" do
      winner = Poker::Hand.new(%w(5D 8C 9S JS AC))
      loser  = Poker::Hand.new(%w(2C 5C 7D 8S QH))

      expect(winner).to be > loser
    end

  end
end
