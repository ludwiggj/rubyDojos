require "test/unit"
require_relative "card"
require_relative "hand"

describe Hand do

  # This may be testing a redundant method!
  describe "highest_card" do

    it "returns highest card in hand" do
      king_high = Hand.new("2H 3D 8S KC 5C")
      
      expect(king_high.highest_card).to eq(Card.new("KC"))
      expect(king_high.highest_card.value).to eq("K")
    end

  end

  describe "<=> operator" do

    it "ranks hands based on highest card in hand" do
      king_high  = Hand.new("2H 3D 8S KC 5C")
      queen_high = Hand.new("QH 3D JS 10C 5C")
      
      expect(king_high <=> queen_high).to eq(1)
      expect(king_high <=>  king_high).to eq(0)
      
      king_high_then_eight = king_high
      king_high_then_queen = Hand.new("QH 3D KS 10C 5C")
      
      expect(king_high_then_eight <=> king_high_then_queen).to eq(-1)
    end
    
    it "returns 1 as a pair beats a queen" do
      a_pair  = Hand.new("2H 2D 8S 3C 5C")
      a_queen = Hand.new("QH 3D JS 10C 5C")

      expect(a_pair <=> a_queen).to eq(1)
    end

    it "returns 1 as a higher pair beats a lower pair" do
      a_pair_of_8s = Hand.new("8H 2D 8S 3C 5C")
      a_pair_of_3s = Hand.new("QH 3D JS 3C 5C")
      
      expect(a_pair_of_8s <=> a_pair_of_3s).to eq(1)
    end
    
    it "returns -1 as a pair of 8s 'queen high' beats a pair of 8s 'five high'" do
      a_pair_of_8s_five_high  = Hand.new("8H 2D 8S 3C 5C")
      a_pair_of_8s_queen_high = Hand.new("QH 8D JS 8C 5C")
      
      expect(a_pair_of_8s_five_high <=> a_pair_of_8s_queen_high).to eq(-1)
    end
    
    it "returns 0 as pairs and remaining cards have same values" do
      a_pair_of_8s_five_high       = Hand.new("8H 2D 8S 3C 5C") 
      another_pair_of_8s_five_high = Hand.new("2H 8D 3S 8C 5S")
      
      expect(a_pair_of_8s_five_high <=> another_pair_of_8s_five_high).to eq(0)
    end

  end

  describe "pair" do

    it "returns details if hand contains a pair" do
      a_pair_of_8s = Hand.new("2H 8D 8S KC 5C")
      
      expect(a_pair_of_8s.pair.tiebreaker).to eq("8")
    end

    it "returns nil if a hand does not contain a pair" do
      king_high = Hand.new("2H 9D 8S KC 5C")
      
      expect(king_high.pair).to eq(nil)
    end

  end
end
