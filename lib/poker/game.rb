module Poker
  class Game

    attr_reader :all_hands

    def initialize(game)
      # Attempt to open the file, or fallback
      # to a string containing space-sep cards
      # with line breaks
      game_content = game.to_s.end_with?('.txt') ? File.read(game) : game
      @all_hands = load_game_from_content(game_content)

      # make sure the hands are all valid
      validate_game!(@all_hands)
    end

    def play
      all_hands.map do |play|
        lh = play[:player_one]
        rh = play[:player_two]

        begin
          winner = case
          when lh > rh then :player_one
          when rh > lh then :player_two
          else :tie
          end

          {
            winner: winner,
            player_one: { rank: lh.rank, cards: lh.cards.map(&:card_code) },
            player_two: { rank: rh.rank, cards: rh.cards.map(&:card_code) }
          }
        rescue => e
          puts e
          puts lh.cards.map(&:card_code).inspect
          puts rh.cards.map(&:card_code).inspect
        end
      end
    end

    private

    def load_game_from_content(game_content)
      game_content.split("\n").map do |line|
        cards = line.split
        {
          player_one: Poker::Hand.new(cards[0..4]),
          player_two: Poker::Hand.new(cards[5..9])
        }
      end
    end

    def validate_game!(hands)
      hands.each do |play|
        # { player_one: <#Poker::Hand>, player_two: <#Poker::Hand> }
        cards = play.map { |player, hand| hand.cards.map(&:card_code) }.flatten.uniq
        raise ArgumentError.new("Invalid play #{cards.inspect}") unless cards.size == 10
      end
    end
  end
end
