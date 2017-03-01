require "test/unit"
require_relative "card"

describe Card do

  it "returns created cards" do
    expect(Card.new("2H").to_s).to eq("2H")
    expect(Card.new("10D").to_s).to eq("10D")
  end

  describe "< operator" do
    it "can compare cards" do
      expect(Card.new("2H")  < Card.new("3H")).to eq(true)
      expect(Card.new("2H")  < Card.new("JH")).to eq(true)
      expect(Card.new("QH")  < Card.new("KH")).to eq(true)
      expect(Card.new("10H") < Card.new("AD")).to eq(true)
     end
  end

  describe "== operator" do
    it "can equate cards" do
      expect(Card.new("2H") == Card.new("2C")).to eq(true)
      expect(Card.new("KH") == Card.new("KH")).to eq(true)
      expect(Card.new("KH") == Card.new("QH")).to eq(false)
    end
  end

  describe "<=> operator" do
    it "can compare cards" do
      expect(Card.new("2H")  <=> Card.new("2C")).to eq(0)
      expect(Card.new("KH")  <=> Card.new("KH")).to eq(0)
      expect(Card.new("10H") <=> Card.new("AD")).to eq(-1)
    end
  end
end
