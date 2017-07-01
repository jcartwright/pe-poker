module Poker
  class Game

    def initialize(game_file)
      @all_hands = IO.read(game_file)
    end
  end
end
