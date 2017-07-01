require 'test_helper'

RSpec.describe Poker do
  let(:game_file) {
    File.join(File.dirname(__FILE__),
              '../../spec/fixtures', 'poker.txt')
  }

  it "plays a game based on the game file"
end
