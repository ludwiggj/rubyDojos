require "test/unit"
require_relative "card"

describe Card do

  it "returns created cards" do
    expect(Card.new("2H").to_s).to eq("2H")
    expect(Card.new("10D").to_s).to eq("10D")
  end

  it "< operator can compare cards" do
    expect(Card.new("2H") < Card.new("3H")).to eq(true)
    expect(Card.new("2H") < Card.new("JH")).to eq(true)
    expect(Card.new("QH") < Card.new("KH")).to eq(true)
    expect(Card.new("10H") < Card.new("AD")).to eq(true)
    expect(Card.new("10H") <=> Card.new("AD")).to eq(-1)
  end

  it "<=> operator can equate cards" do
    expect(Card.new("2H")).to eq(Card.new("2C"))
    expect(Card.new("KH")).to eq(Card.new("KH"))
    expect(Card.new("2H") <=> Card.new("2C")).to eq(0)
    expect(Card.new("KH") <=> Card.new("KH")).to eq(0)
  end
end

=begin

describe class
  # can use subject.

  before # executed before each block that follows

  describe "method"
    it ""

    context "...."
    before # executed before each block that follows (its etc.)
    it ""
    it ""
    context ""
  end
end    
=end
