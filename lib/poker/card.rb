module Poker
  class Card
    include Comparable

    POSSIBLE_VALUES = %w(2 3 4 5 6 7 8 9 T J Q K A).freeze
    POSSIBLE_SUITS = %w(H D C S).freeze

    attr_reader :card_code, :value, :suit, :weight

    def initialize(card_code)
      @card_code = normalize_code(card_code)
      @value, @suit = validate_code!(@card_code)
    end

    def <=>(other)
      weight <=> other.weight
    end

    def weight
      @weight ||= value_to_weight(@value)
    end

    def pip?
      @value <= 10
    end

    def face?
      @value > 10
    end

    private

    def normalize_code(card_code)
      card_code.to_s.upcase[0..1]
    end

    def validate_code!(card_code)
      val, suit = card_code.chars
      case
      when !POSSIBLE_VALUES.include?(val)
        raise ArgumentError.new("#{val} is not a possible value")
      when !POSSIBLE_SUITS.include?(suit)
        raise ArgumentError.new("#{suit} is not a possible suit")
      end

      [val, suit]
    end

    def value_to_weight(val)
      case
      when %w(2 3 4 5 6 7 8 9).include?(val) then val.to_i
      when val == 'T' then 10
      when val == 'J' then 11
      when val == 'Q' then 12
      when val == 'K' then 13
      when val == 'A' then 14
      else 0
      end
    end
  end
end
