class Poker::Hand
  VALID_CARD_COUNT = 5

  attr_reader :cards

  def initialize(cards)
    @cards = validate_cards!(cards)
  end


  private

  def validate_cards!(cards)
    case
    when cards.size < VALID_CARD_COUNT
      raise ArgumentError.new("Not enough cards to make a hand")
    when cards.size > VALID_CARD_COUNT
      raise ArgumentError.new("Too many cards to make a hand")
    when cards.uniq.size != VALID_CARD_COUNT
      raise ArgumentError.new("Cannot make a hand with duplicate cards")
    end

    cards
  end

end
