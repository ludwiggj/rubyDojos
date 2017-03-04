require "test/unit"
require_relative "card"
require_relative "hand"

describe Hand do

  queen_high             = Hand.new("QH 3D JS 10C 5C")
  a_pair                 = Hand.new("AH JD JS 3D 5H")
  a_pair_of_jacks        = Hand.new("QH JD JS 3D 5H")
  two_pairs              = Hand.new("3H 2D 3S 2C 5C")
  two_pairs_kings_and_5s = Hand.new("AH KD KS 5D 5H")
  three_2s               = Hand.new("3H 2D 2S 2C 5C")
  four_kings             = Hand.new("2H KS KH KC KD")
  a_straight             = Hand.new("4H 2H 3S 5C 6D")
  a_straight_jack_high   = Hand.new("10S 8H JC 9D 7C")
  
  context "highest ranked hand in play is a highest card" do
    king_high  = Hand.new("2H 3D 8S KC 5C")
    
    describe "> operator" do
      it "king high beats queen high" do
        expect(king_high  > queen_high).to eq(true)
      end
      
      it "king high then queen beats king high then eight" do
        king_high_then_queen = Hand.new("QH 3D KS 10C 5C")
        king_high_then_eight = Hand.new("2H 3D 8S KC 5C")
      
        expect(king_high_then_queen > king_high_then_eight).to eq(true)
      end
    end
    
    describe "== operator" do
      it "equates king high hands with identical values" do
        another_king_high = Hand.new("2C 3S 8H KD 5S")
        
        expect(king_high == another_king_high).to eq(true)
      end
    end
  end

  context "highest ranked hand in play is a pair" do
    a_pair_of_aces_king_high = Hand.new("AH 2D AS 3C KC")

    describe "> operator" do
      it "a pair beats a queen" do
        expect(a_pair > queen_high).to eq(true)
      end
      
      it "a higher pair beats a lower pair" do
        a_pair_of_aces  = Hand.new("AH 2D AS 3C 5C")
      
        expect(a_pair_of_aces > a_pair_of_jacks).to eq(true)
      end

      it "a pair of aces 'king high' beats a pair of aces 'queen high'" do
        a_pair_of_aces_queen_high = Hand.new("QH AD JS AC 5C")
      
        expect(a_pair_of_aces_king_high > a_pair_of_aces_queen_high).to eq(true)
      end
    end

    describe "== operator" do
      it "equates hands when pairs and remaining cards have same values" do
        another_pair_of_aces_king_high = Hand.new("AD 3D AC 2C KS")
      
        expect(a_pair_of_aces_king_high == another_pair_of_aces_king_high).to eq(true)
      end
    end
  end

  context "highest rank hand in play is two pairs" do
    two_pairs_jack_high = Hand.new("6H KD KS 6S JH")

    describe "> operator" do
      it "two pairs beats a single pair" do
        expect(two_pairs > a_pair).to eq(true)
      end

      it "two pairs 'kings and 6s' beats two pairs 'kings and 5s'" do
        two_pairs_kings_and_6s = Hand.new("KH 6D 3S 6C KC")
    
        expect(two_pairs_kings_and_6s > two_pairs_kings_and_5s).to eq(true)
      end
      
      it "two pairs 'queen high' beats two identical pairs 'jack high'" do
        two_pairs_queen_high = Hand.new("KH 6D QS 6C KC")
      
        expect(two_pairs_queen_high > two_pairs_jack_high).to eq(true)
      end
    end
    
    describe "== operator" do
      it "equates hands when two pairs and remaining card have same values" do
        another_two_pairs_jack_high = Hand.new("KC KH JD 6C 6D")
      
        expect(two_pairs_jack_high == another_two_pairs_jack_high).to eq(true)
      end
    end
  end

  context "highest rank hand in play is three of a kind" do
    describe "> operator" do
      it "three of a kind beats a single pair " do
        expect(three_2s > a_pair).to eq(true)
      end
    end
  end

  context "highest rank hand in play is a straight" do
    describe "> operator" do
      it "a straight beats three of a kind" do
        expect(a_straight > three_2s).to eq(true)
      end
    end
    
    describe "< operator" do
      it "two pairs is beaten by a straight" do
        expect(two_pairs < a_straight).to eq(true)
      end
      
      it "a straight 7 high is beaten by a straight jack high" do
        a_straight_seven_high = Hand.new("4S 6H 3C 7D 5D")

        expect(a_straight_seven_high < a_straight_jack_high).to eq(true)
      end
    end

    describe "== operator" do
      it "equates hands when two straights have same highest card" do
        another_straight_jack_high   = Hand.new("8C 9C 7D 10D JS")
      
        expect(a_straight_jack_high == another_straight_jack_high).to eq(true)
      end
    end
  end

  context "highest rank hand in play is three of a kind" do
    describe "> operator" do
      it "three of a kind beats a single pair " do
        expect(three_2s > a_pair).to eq(true)
      end
    end
  end

  context "highest rank hand in play is a straight" do
    describe "> operator" do
      it "a straight beats three of a kind" do
        expect(a_straight > three_2s).to eq(true)
      end
    end
    
    describe "< operator" do
      it "two pairs is beaten by a straight" do
        expect(two_pairs < a_straight).to eq(true)
      end
      
      it "a straight 7 high is beaten by a straight jack high" do
        a_straight_seven_high = Hand.new("4S 6H 3C 7D 5D")
        a_straight_jack_high  = Hand.new("10S 8H JC 9D 7C")

        expect(a_straight_seven_high < a_straight_jack_high).to eq(true)
      end
    end
  end

  context "highest rank hand in play is four of a kind" do
    describe "> operator" do
      it "four of a kind beats two pairs" do
        expect(four_kings > two_pairs).to eq(true)
      end
    end
  end

  context "highest rank hand in play is four of a kind" do
    describe "> operator" do
      it "four of a kind beats two pairs" do
        expect(four_kings > two_pairs).to eq(true)
      end
    end
  end

  describe "pair" do
    it "returns details if hand contains a pair" do
      expect(a_pair_of_jacks.pair.tiebreaker).to eq(CardValue::JACK)
    end

    it "returns nil if a hand does not contain a pair" do
      king_high = Hand.new("2H 9D 8S KC 5C")
      
      expect(king_high.pair).to eq(nil)
    end
  end

  describe "two_pair" do
    it "returns details if hand contains two pairs" do
      expect(two_pairs_kings_and_5s.two_pair.tiebreaker).to eq([CardValue::KING, CardValue::FIVE])
    end

    it "returns nil if a hand does not contain two pairs" do
      pair_kings = Hand.new("2H 7D 8S KC KD")
      
      expect(pair_kings.two_pair).to eq(nil)
    end
  end
  
  describe "three_of_a_kind" do
    it "returns details if hand contains three of a kind" do
      expect(three_2s.three_of_a_kind.tiebreaker).to eq(CardValue::TWO)
    end

    it "returns nil if a hand does not contain three of a kind" do
      expect(two_pairs.three_of_a_kind).to eq(nil)
    end
  end

  describe "four_of_a_kind" do
    it "returns details if hand contains four of a kind" do
      expect(four_kings.four_of_a_kind.tiebreaker).to eq(CardValue::KING)
    end

    it "returns nil if a hand does not contain four of a kind" do
      two_pairs = Hand.new("2H 7D 2S KC KD")
      
      expect(two_pairs.four_of_a_kind).to eq(nil)
    end
  end
  
  describe "straight" do
    it "returns details if hand contains a straight" do
      expect(a_straight.straight.tiebreaker).to eq(CardValue::SIX)
    end

    it "returns nil if a hand does not contain a straight" do
      nearly_a_straight = Hand.new("2H 5D AS 3C 4D")
      
      expect(nearly_a_straight.straight).to eq(nil)
    end
  end
end
