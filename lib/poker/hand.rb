class Poker::Hand
  VALID_CARD_COUNT = 5

  attr_reader :cards

  def initialize(cards)
    @cards = validate_cards!(cards)
  end

  def face_value
    cards.reduce(0) { |sum, card|
      val = card.to_s[0] # first character is val/face
      sum + case
      when %w(2 3 4 5 6 7 8 9).include?(val) then val.to_i
      when val == 'T' then 10
      when val == 'J' then 11
      when val == 'Q' then 12
      when val == 'K' then 13
      when val == 'A' then 14
      else 0
      end
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

end
