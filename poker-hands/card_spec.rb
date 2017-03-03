require "test/unit"
require_relative "card"

describe Card do

  describe "to_s method" do
    
    it "returns created cards" do
      expect(Card.new("2H").to_s).to eq("2H")
      expect(Card.new("10D").to_s).to eq("10D")
      expect(Card.new("JD").to_s).to eq("JD")
    end

  end

  describe "< operator" do

    it "can compare cards" do
      expect(Card.new("2H")  < Card.new("3H")).to eq(true)
      expect(Card.new("2H")  < Card.new("JH")).to eq(true)
      expect(Card.new("QH")  < Card.new("KH")).to eq(true)
      expect(Card.new("10H") < Card.new("AD")).to eq(true)
      expect(Card.new("3H")  < Card.new("3S")).to eq(true)
     end

  end

  describe "== operator" do

    it "can equate cards" do
      expect(Card.new("KH") == Card.new("KH")).to eq(true)
    end

  end

  describe "!= operator" do

    it "can discriminate cards" do
      expect(Card.new("2H") != Card.new("2C")).to eq(true)
      expect(Card.new("KH") != Card.new("QH")).to eq(true)
    end

  end
end
