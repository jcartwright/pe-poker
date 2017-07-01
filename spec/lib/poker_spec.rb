require 'test_helper'

RSpec.describe Poker do
  let(:game_file) {
    File.join(File.dirname(__FILE__),
              '../../spec/fixtures', 'poker.txt')
  }

  it "should init with a game file" do
    expect(Poker.new(game_file))
  end
end
