require "test/unit"
require_relative "card"
require_relative "hand"

describe Hand do

  describe "> operator" do

    it "king high beats queen high" do
      king_high  = Hand.new("2H 3D 8S KC 5C")
      queen_high = Hand.new("QH 3D JS 10C 5C")
      
      expect(king_high  > queen_high).to eq(true)
    end

    it "a pair beats a queen" do
      a_pair  = Hand.new("2H 2D 8S 3C 5C")
      a_queen = Hand.new("QH 3D JS 10C 5C")

      expect(a_pair > a_queen).to eq(true)
    end

    it "a higher pair beats a lower pair" do
      a_pair_of_aces = Hand.new("AH 2D AS 3C 5C")
      a_pair_of_jacks = Hand.new("QH JD JS 3D 5H")
      
      expect(a_pair_of_aces > a_pair_of_jacks).to eq(true)
    end

    it "two pairs beats a single pair" do
      two_pairs = Hand.new("3H 2D 3S 2C 5C")
      a_pair    = Hand.new("AH JD JS 3D 5H")
      
      expect(two_pairs > a_pair).to eq(true)
    end

  end

  describe "< operator" do

    it "king high then eight loses to king high then queen" do
      king_high_then_eight = Hand.new("2H 3D 8S KC 5C")
      king_high_then_queen = Hand.new("QH 3D KS 10C 5C")
      
      expect(king_high_then_eight < king_high_then_queen).to eq(true)
    end

    it "a pair of aces 'queen high' loses to a pair of aces 'king high'" do
      a_pair_of_aces_queen_high = Hand.new("QH AD JS AC 5C")
      a_pair_of_aces_king_high  = Hand.new("AH 2D AS 3C KC")
      
      expect(a_pair_of_aces_queen_high < a_pair_of_aces_king_high).to eq(true)
    end

    it "two pairs 'kings and 5s' loses to two pairs 'kings and 6s'" do
      two_pairs_kings_and_5s = Hand.new("AH KD KS 5D 5H")
      two_pairs_kings_and_6s = Hand.new("KH 6D 3S 6C KC")
      
      expect(two_pairs_kings_and_5s < two_pairs_kings_and_6s).to eq(true)
    end
    
    it "two pairs 'jack high' loses to two pairs 'queen high'" do
      two_pairs_jack_high  = Hand.new("6H KD KS 6S JH")
      two_pairs_queen_high = Hand.new("KH 6D QS 6C KC")
      
      expect(two_pairs_jack_high < two_pairs_queen_high).to eq(true)
    end

    it "a single pair loses to three of a kind" do
      a_pair          = Hand.new("AH JD JS 3D 5H")
      three_of_a_kind = Hand.new("3H 2D 2S 2C 5C")
      
      expect(a_pair < three_of_a_kind).to eq(true)
    end
  end

  describe "== operator" do

    it "equates king high hands with identical values" do
      king_high          = Hand.new("2H 3D 8S KC 5C")
      another_king_high  = Hand.new("2C 3S 8H KD 5S")
      
      expect(king_high ==  another_king_high).to eq(true)
    end

    it "equates hands when pairs and remaining cards have same values" do
      a_pair_of_8s_five_high       = Hand.new("8H 2D 8S 3C 5C") 
      another_pair_of_8s_five_high = Hand.new("2H 8D 3S 8C 5S")
      
      expect(a_pair_of_8s_five_high == another_pair_of_8s_five_high).to eq(true)
    end

    it "equates hands when two pairs and remaining card have same values" do
      two_pairs_five_high         = Hand.new("8H 3D 8S 3C 5C")
      another_two_pairs_five_high = Hand.new("3H 8D 3S 8C 5S")
      
      expect(two_pairs_five_high == another_two_pairs_five_high).to eq(true)
    end

  end


  describe "pair" do

    it "returns details if hand contains a pair" do
      a_pair_of_8s = Hand.new("2H 8D 8S KC 5C")
      
      expect(a_pair_of_8s.pair.tiebreaker).to eq(8)
    end

    it "returns nil if a hand does not contain a pair" do
      king_high = Hand.new("2H 9D 8S KC 5C")
      
      expect(king_high.pair).to eq(nil)
    end

  end

  describe "two_pair" do
    it "returns details if hand contains two pairs" do
      two_pairs_kings_and_8s = Hand.new("2H 8D 8S KC KD")

      expect(two_pairs_kings_and_8s.two_pair.tiebreaker).to eq([13, 8])
    end

    it "returns nil if a hand does not contain two pairs" do
      pair_kings = Hand.new("2H 7D 8S KC KD")
      
      expect(pair_kings.two_pair).to eq(nil)
    end
  end
  
  describe "three_of_a_kind" do
    it "returns details if hand contains three of a kind" do
      three_kings = Hand.new("2H KS 8S KC KD")

      expect(three_kings.three_of_a_kind.tiebreaker).to eq(13)
    end

    it "returns nil if a hand does not contain three of a kind" do
      two_pairs = Hand.new("2H 7D 2S KC KD")
      
      expect(two_pairs.three_of_a_kind).to eq(nil)
    end
  end
end
