require 'test_helper'

RSpec.describe Poker::Game do
  let(:game_file) {
    File.join(File.dirname(__FILE__),
              '../../../spec/fixtures', 'poker.txt')
  }

  context "#initialize" do
    it "succeeds with a valid game file" do
      expect(Poker::Game.new(game_file))
    end

    it "fails with a missing file" do
      expect {
        Poker::Game.new('/path/to/missing/file')
      }.to raise_error(SystemCallError)
    end
  end
end
