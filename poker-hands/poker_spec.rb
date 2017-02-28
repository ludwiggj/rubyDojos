require "test/unit"
require_relative "card"
require_relative "hand"

describe "PokerHands", "basic scoring" do

  it "should create a card" do
    expect(Card.new("2H").to_s).to eq("2H")
    expect(Card.new("10D").to_s).to eq("10D")
  end

  it "< should be able to compare cards" do
    expect(Card.new("2H") < Card.new("3H")).to eq(true)
    expect(Card.new("2H") < Card.new("JH")).to eq(true)
    expect(Card.new("QH") < Card.new("KH")).to eq(true)
    expect(Card.new("10H") < Card.new("AD")).to eq(true)
    expect(Card.new("10H") <=> Card.new("AD")).to eq(-1)
  end

  it "= should be able to equate cards" do
    expect(Card.new("2H")).to eq(Card.new("2C"))
    expect(Card.new("KH")).to eq(Card.new("KH"))
    expect(Card.new("KH") <=> Card.new("KH")).to eq(0)
  end

  # This may be testing a redundant method!
  it "should be able to find highest card in a hand" do
    expect(Hand.new("2H 3D 8S KC 5C").highest_card).to eq(Card.new("KC"))
    expect(Hand.new("QH 3D QS JC 5C").highest_card.value).to eq("Q")
  end

  it "should be able to find best hand based on highest card in a hand" do
    expect(Hand.new("2H 3D 8S KC 5C") <=> Hand.new("QH 3D JS 10C 5C")).to eq(1)
    expect(Hand.new("2H 3D 8S KC 5C") <=> Hand.new("QH 3D KS 10C 5C")).to eq(-1)
    expect(Hand.new("2H 3D 8S KC 5C") <=> Hand.new("2H 3D 8S KC 5C")).to eq(0)
  end
end
