class Poker::Hand
  VALID_CARD_COUNT = 5

  attr_reader :cards

  def initialize(cards)
    @cards = parse_cards(cards)
  end

  include Comparable
  def <=>(other)
    lh, rh = rank, other.rank

    if lh != rh # not a tie
      lh <=> rh
    else # a possible tie
      compare_tie_breakers(self, other)
    end
  end

  def rank
    case 
    when royal_flush? then 900
    when straight_flush? then 800
    when four_of_a_kind? then 700
    when full_house? then 600
    when flush? then 500
    when straight? then 400
    when three_of_a_kind? then 300
    when two_pair? then 200
    when one_pair? then 100
    when high_card? then 0
    end
  end

  def royal_flush?
    cards.max.ace? &&
    same_suit?(cards) &&
    sequential?(cards)
  end

  def straight_flush?
    same_suit?(cards) &&
    sequential?(cards)
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

  def high_card?
    !same_suit?(cards) &&
    !sequential?(cards) &&
    !group_weights(cards).any?
  end

  private

  def parse_cards(cards)
    cards = cards.split if cards.respond_to?(:split)
    validate_cards!(cards).map do |card_code|
      Poker::Card.new(card_code)
    end.sort.reverse
  end

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

  def card_groups_by(cards, method = :weight)
    cards.group_by(&method)
  end

  def group_weights(cards)
    # select groups with counts > 1
    # sort them by set size, descending
    # and return an array of weights
    groups = card_groups_by(cards, :weight).select { |weight, set| set.size > 1 }
    groups.sort_by { |weight, set| set.size }.reverse.map(&:first)
  end

  def kicker_weights(cards)
    # select only single (aka 'kicker') cards
    # and return their weights in descening order
    kickers = card_groups_by(cards).select { |weight, set| set.size == 1 }
    kickers.sort_by { |weight, set| weight }.reverse.map(&:first)
  end

  def same_suit?(cards)
    cards.map(&:suit).uniq.size == 1
  end

  def sequential?(cards)
    weights = cards.map(&:weight)
    weights.uniq.size == VALID_CARD_COUNT &&
    (weights.min..weights.max).size == VALID_CARD_COUNT
  end

  def compare_tie_breakers(lh, rh)
    case
    when # hands with no tie-breaker
      lh.royal_flush? then 0
    when # hands with sets
      lh.four_of_a_kind?,
      lh.full_house?,
      lh.three_of_a_kind?,
      lh.two_pair?,
      lh.one_pair? then compare_card_sets(lh, rh)
    when # hands without sets
      lh.straight_flush?,
      lh.flush?,
      lh.straight?,
      lh.high_card? then compare_high_cards(lh.cards, rh.cards)
    end
  end

  def compare_high_cards(lh, rh)
    lc, rc = lh.map(&:weight)
               .zip(rh.map(&:weight))
               .find { |set| set[0] != set[1] }
    lc <=> rc
  end

  def compare_card_sets(lh, rh)
    lg, rg = group_weights(lh.cards), group_weights(rh.cards)
    lw, rw = lg.zip(rg).find { |set| set[0] != set[1] }

    (lw || rw) ? (lw <=> rw) : compare_kicker_cards(lh, rh)
  end

  def compare_kicker_cards(lh, rh)
    lkw, rkw = kicker_weights(lh.cards), kicker_weights(rh.cards)
    lw, rw = lkw.zip(rkw).find { |set| set[0] != set[1] }
    
    (lw || rw) ? (lw <=> rw) : 0
  end
end
