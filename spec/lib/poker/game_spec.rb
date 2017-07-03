require 'test_helper'

RSpec.describe Poker::Game do
  let(:game_file) {
    File.join(File.dirname(__FILE__),
              '../../../spec/fixtures', 'poker.txt')
  }
  let(:game_string) {
    <<-GAME
    5H 5C 6S 7S KD 2C 3S 8S 8D TD
    5D 8C 9S JS AC 2C 5C 7D 8S QH
    2D 9C AS AH AC 3D 6D 7D TD QD
    4D 6S 9H QH QC 3D 6D 7H QD QS
    2H 2D 4C 4D 4S 3C 3D 3S 9S 9D
    GAME
  }

  describe "#initialize" do
    it "succeeds with a valid game file" do
      expect(Poker::Game.new(game_file)).to be_a(Poker::Game)
    end

    it "succeeds with a valid list of cards" do
      expect(Poker::Game.new(game_string)).to be_a(Poker::Game)
    end

    it "fails with a missing file" do
      expect {
        Poker::Game.new('/path/to/missing/file.txt')
      }.to raise_error(SystemCallError)
    end

    it "parses game content into a list of hands" do
      game = Poker::Game.new(game_file)
      expect(game.all_hands.size).to eq(1000)

      game = Poker::Game.new(game_string)
      expect(game.all_hands.size).to eq(5)
    end

    it "fails with an invalid card" do
      # invalid card code 0H
      bad_game = "0H 5C 6S 7S KD 2C 3S 8S 8D TD"
      expect {
        Poker::Game.new(bad_game)
      }.to raise_error(ArgumentError)
    end

    context "fails with an invalid hand" do
      it "due to duplicate card `5C` in player's hands" do
        bad_game = "5H 5C 6S 7S KD 5C 3S 8S 8D TD"
        expect {
          Poker::Game.new(bad_game)
        }.to raise_error(ArgumentError)
      end

      it "due to too few cards" do
        bad_game = "5C 6S 7S KD 2C 3S 8S 8D TD"
        expect {
          Poker::Game.new(bad_game)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#play" do
    let(:game) { Poker::Game.new(game_string) }

    it "determines the results of each hand" do
      results = game.play
      expected = [:player_two, :player_one, :player_two, :player_one, :player_one]
      actual = results.map { |play| play[:winner] }

      expect(actual).to eq(expected)
    end

    it "returns the results of the game" do
      full_game = Poker::Game.new(game_file)
      results = full_game.play

      puts "\n\n**** RESULTS ****"

      player_one_tally = results.select { |play| play[:winner] == :player_one }
      puts "Player 1: #{player_one_tally.size}"

      player_two_tally = results.select { |play| play[:winner] == :player_two }
      puts "Player 2: #{player_two_tally.size}"

      ties = results.select { |play| play[:winner] == :tie }
      puts "Ties: #{ties.size}"

      puts "*****************\n\n"

      expect(player_one_tally.size).to eq(376)
      expect(player_two_tally.size).to eq(624)
      expect(ties.size).to eq(0)
    end
  end
end
