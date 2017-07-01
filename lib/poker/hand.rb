class Poker::Hand
  include Comparable

  VALID_CARD_COUNT = 5

  attr_reader :cards

  def initialize(cards)
    cards = cards.split if cards.respond_to?(:split)
    @cards = parse_cards(validate_cards!(cards))
  end

  def <=>(other)
    rank <=> other.rank
  end

  def face_value
    cards.reduce(0) { |sum, card|
      sum + card.weight
    }
  end

  def high_card
    cards.max
  end

  def rank
    # royal flush => all face (ace..ten), all same suit
    # uniq on suit, face value of 60
    case 
    when royal_flush? then 100
    else
      high_card.weight
    end
  end

  def royal_flush?
    face_value == 60 && same_suit?(cards)
  end

  def straight_flush?
    same_suit?(cards) && sequential?(cards)
  end

  def four_of_a_kind?
    groups = card_groups_by(cards, :weight)
    groups.any? { |weight, cards| cards.size == 4 } 
  end

  def full_house?
    groups = card_groups_by(cards, :weight)
    groups.map { |weight, cards| cards.size }.sort == [2,3]
  end

  def flush?
    same_suit?(cards)
  end

  def straight?
    sequential?(cards)
  end

  def three_of_a_kind?
    groups = card_groups_by(cards, :weight)
    groups.any? { |weight, cards| cards.size == 3 } 
  end

  def two_pair?
    groups = card_groups_by(cards, :weight)
    sets_of_2_or_more = groups.select { |weight, cards| cards.size >= 2 }
    sets_of_2_or_more.size == 2
  end

  def one_pair?
    card_groups_by(cards, :weight).size < VALID_CARD_COUNT
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

  def card_groups_by(cards, method = :weight)
    cards.group_by(&method)
  end

  def same_suit?(cards)
    cards.map(&:suit).uniq.size == 1
  end

  def sequential?(cards)
    weights = cards.map(&:weight)
    (weights.min..weights.max).size == VALID_CARD_COUNT
  end
end
