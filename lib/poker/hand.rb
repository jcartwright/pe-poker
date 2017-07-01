class Poker::Hand
  VALID_CARD_COUNT = 5

  attr_reader :cards

  def initialize(cards)
    @cards = parse_cards(validate_cards!(cards))
  end

  def face_value
    cards.reduce(0) { |sum, card|
      sum + card.weight
    }
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

  def parse_cards(cards)
    cards.map do |card_code|
      Poker::Card.new(card_code)
    end
  end

end
