module Poker
  class Card
    POSSIBLE_VALUES = %w(2 3 4 5 6 7 8 9 T J Q K A).freeze
    POSSIBLE_SUITS = %w(H D C S).freeze

    attr_reader :value, :suit

    def initialize(card_code)
      @value, @suit = validate_code!(card_code)
    end

    def pip?
      @value <= 10
    end

    def face?
      @value > 10
    end

    private

    def validate_code!(card_code)
      val, suit = card_code.to_s.upcase[0..1].chars
      case
      when !POSSIBLE_VALUES.include?(val)
        raise ArgumentError.new("#{val} is not a possible value")
      when !POSSIBLE_SUITS.include?(suit)
        raise ArgumentError.new("#{suit} is not a possible suit")
      end

      [val, suit]
    end
  end
end
