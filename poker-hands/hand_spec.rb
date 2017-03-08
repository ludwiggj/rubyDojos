require "test/unit"
require_relative "card"
require_relative "hand"

describe Hand do
  
  def hand(handy_string)
    Hand.new(handy_string)
  end

  let(:queen_high)                  {  "QH 3D JS 10C 5C" }
  let(:king_high)                   {  "2H 3D 8S  KC 5C" }
  let(:a_pair)                      {  "AH JD JS  3D 5H" }
  let(:a_pair_of_jacks)             {  "QH JD JS  3D 5H" }
  let(:two_pairs)                   {  "3H 2D 3S  2C 5C" }
  let(:two_pairs_kings_and_fives)   {  "AH KD KS  5D 5H" }
  let(:three_of_a_kind)             {  "3H 2D 2S  2C 5C" }
  let(:a_straight)                  {  "4H 2H 3S  5C 6D" }
  let(:a_straight_jack_high)        { "10S 8H JC  9D 7C" }
  let(:a_flush)                     {  "2H 5H AH  8H 4H" }
  let(:a_flush_eight_high)          {  "2S 6S 3S  4S 8S" }
  let(:a_full_house)                {  "3H 2D 3S  2C 3C" }
  let(:four_kings)                  {  "2H KS KH  KC KD" }
  let(:a_straight_flush)            {  "4H 2H 3H  5H 6H" }
  let(:a_straight_flush_eight_high) { " 5D 8D 6D  7D 4D" }

  it "can parse a hand with lots of spaces" do
    expect(hand("AS   AD  AC   AH   KC").to_s).to eq('["AS", "AH", "AD", "AC", "KC"]')
  end


  context "highest ranked hand in play is a highest card" do
    
    describe "> operator" do
      it "king high beats queen high" do
        expect(hand(king_high) > hand(queen_high)).to eq(true)
      end
      
      it "king high then queen beats king high then eight" do
        king_high_then_queen = "QH 3D KS 10C 5C"
        king_high_then_eight = "2H 3D 8S  KC 5C"
      
        expect(hand(king_high_then_queen) > hand(king_high_then_eight)).to eq(true)
      end
    end
    
    describe "== operator" do
      it "equates king high hands with identical values" do
        another_king_high = "2C 3S 8H KD 5S"
        
        expect(hand(king_high) == hand(another_king_high)).to eq(true)
      end
    end
  end


  context "highest ranked hand in play is a pair" do
    a_pair_of_aces_king_high = "AH 2D AS 3C KC"

    describe "> operator" do
      it "a pair beats a queen" do
        expect(hand(a_pair) > hand(queen_high)).to eq(true)
      end

      it "a higher pair beats a lower pair" do
        a_pair_of_aces  = "AH 2D AS 3C 5C"
        a_pair_of_jacks = "QH JD JS 3D 5H"
      
        expect(hand(a_pair_of_aces) > hand(a_pair_of_jacks)).to eq(true)
      end

      it "a pair of aces 'king high' beats a pair of aces 'queen high'" do
        a_pair_of_aces_queen_high = "QH AD JS AC 5C"
      
        expect(hand(a_pair_of_aces_king_high) > hand(a_pair_of_aces_queen_high)).to eq(true)
      end
    end

    describe "== operator" do
      it "equates hands when pairs and remaining cards have same values" do
        another_pair_of_aces_king_high = "AD 3D AC 2C KS"
      
        expect(hand(a_pair_of_aces_king_high) == hand(another_pair_of_aces_king_high)).to eq(true)
      end
    end
  end


  context "highest rank hand in play is two pairs" do
    two_pairs_kings_and_sixes_jack_high = "6H KD KS 6S JH"

    describe "> operator" do
      it "two pairs beats a single pair" do
        expect(hand(two_pairs) > hand(a_pair)).to eq(true)
      end

      it "two pairs 'kings and sixes' beats two pairs 'kings and fives'" do
        two_pairs_kings_and_sixes = "KH 6D 3S 6C KC"
    
        expect(hand(two_pairs_kings_and_sixes) > hand(two_pairs_kings_and_fives)).to eq(true)
      end
      
      it "two pairs 'kings and sixes queen high' beats two pairs 'kings and sixes jack high'" do
        two_pairs_kings_and_sixes_queen_high = "KH 6D QS 6C KC"
      
        expect(hand(two_pairs_kings_and_sixes_queen_high) > hand(two_pairs_kings_and_sixes_jack_high)).to eq(true)
      end
    end
    
    describe "== operator" do
      it "equates hands when two pairs and remaining card have same values" do
        another_two_pairs_kings_and_sixes_jack_high = "KC KH JD 6C 6D"
      
        expect(hand(two_pairs_kings_and_sixes_jack_high) == hand(another_two_pairs_kings_and_sixes_jack_high)).to eq(true)
      end
    end
  end


  context "highest rank hand in play is three of a kind" do

    describe "> operator" do
      it "three of a kind beats a single pair " do
        expect(hand(three_of_a_kind) > hand(a_pair)).to eq(true)
      end
    end
  end


  context "highest rank hand in play is a straight" do

    describe "> operator" do
      it "a straight beats three of a kind" do
        expect(hand(a_straight) > hand(three_of_a_kind)).to eq(true)
      end
    end
    
    describe "< operator" do
      it "two pairs is beaten by a straight" do
        expect(hand(two_pairs) < hand(a_straight)).to eq(true)
      end
      
      it "a straight seven high is beaten by a straight jack high" do
        a_straight_seven_high = "4S 6H 3C 7D 5D"

        expect(hand(a_straight_seven_high) < hand(a_straight_jack_high)).to eq(true)
      end
    end

    describe "== operator" do
      it "equates hands when two straights have same highest card" do
        another_straight_jack_high = "8C 9C 7D 10D JS"
      
        expect(hand(a_straight_jack_high) == hand(another_straight_jack_high)).to eq(true)
      end
    end
  end


  context "highest rank hand in play is a flush" do

    describe "> operator" do
      it "a flush beats three of a kind" do
        expect(hand(a_flush) > hand(three_of_a_kind)).to eq(true)
      end
    end
    
    describe "< operator" do
      it "a straight is beaten by a flush" do
        expect(hand(a_straight) < hand(a_flush)).to eq(true)
      end
      
      it "a flush seven high is beaten by a flush eight high" do
        a_flush_seven_high = "2H 5H 6H 4H 7H"

        expect(hand(a_flush_seven_high) < hand(a_flush_eight_high)).to eq(true)
      end
    end
    
    describe "== operator" do
      it "equates hands when two flushes have same highest card" do
        another_flush_eight_high = "2C 4C 3C 8C 6C"
      
        expect(hand(a_flush_eight_high) == hand(another_flush_eight_high)).to eq(true)
      end
    end
  end


  context "highest rank hand in play is a full house" do

    describe "> operator" do
      it "a full house beats a flush" do
        expect(hand(a_full_house) > hand(a_flush)).to eq(true)
      end
    end
    
    it "a full house kings and queens is beaten by a full house aces and twos" do
        a_full_house_kings_and_queens = "KD QD KS QC KC"
        a_full_house_aces_and_twos    = "2D AD AS 2C AC"

        expect(hand(a_full_house_kings_and_queens) < hand(a_full_house_aces_and_twos)).to eq(true)
    end
  end


  context "highest rank hand in play is four of a kind" do
    describe "> operator" do
      it "four of a kind beats two pairs" do
        expect(hand(four_kings) > hand(two_pairs)).to eq(true)
      end
    end
  end


  context "highest rank hand in play is a straight flush" do
    describe "> operator" do
      it "a straight flush beats four of a kind" do
        expect(hand(a_straight_flush) > hand(four_kings)).to eq(true)
      end

      it "a straight flush beats a pair" do
        expect(hand(a_straight_flush) > hand(a_pair)).to eq(true)
      end

      it "a straight flush king high beats a straight flush eight high" do
        a_straight_flush_king_high  = "KD QD 10D 9D JD"

        expect(hand(a_straight_flush_king_high) > hand(a_straight_flush_eight_high)).to eq(true)
      end
    end

    describe "< operator" do
      it "a flush is beaten by a straight flush" do
        expect(hand(a_flush) < hand(a_straight_flush)).to eq(true)
      end

      it "a full house is beaten by a straight flush" do
        expect(hand(a_full_house) < hand(a_straight_flush)).to eq(true)
      end
    end

    describe "== operator" do
      it "equates hands when two straight flushes have same highest card" do
        another_straight_flush_eight_high = "5C 4C 7C 8C 6C"
      
        expect(hand(a_straight_flush_eight_high) == hand(another_straight_flush_eight_high)).to eq(true)
      end
    end
  end


  context "lower level methods, which should really be private!" do

    describe "highest_card" do
      it "returns details if hand contains nothing" do
        expect(hand(queen_high).highest_card.tiebreaker).to eq(CardValue::QUEEN)
      end
    end

    describe "a_pair" do
      it "returns details if hand contains a pair" do
        expect(hand(a_pair_of_jacks).a_pair.tiebreaker).to eq(CardValue::JACK)
      end

      it "returns nil if a hand does not contain a pair" do
        expect(hand(king_high).a_pair).to eq(nil)
      end
    end

    describe "two_pairs" do
      it "returns details if hand contains two pairs" do
        expect(hand(two_pairs_kings_and_fives).two_pairs.tiebreaker).to eq([CardValue::KING, CardValue::FIVE])
      end

      it "returns nil if a hand does not contain two pairs" do
        expect(hand(a_pair_of_jacks).two_pairs).to eq(nil)
      end
    end
  
    describe "three_of_a_kind" do
      it "returns details if hand contains three of a kind" do
        expect(hand(three_of_a_kind).three_of_a_kind.tiebreaker).to eq(CardValue::TWO)
      end

      it "returns nil if a hand does not contain three of a kind" do
        expect(hand(two_pairs).three_of_a_kind).to eq(nil)
      end
    end

    describe "straight" do
      it "returns details if hand is a straight" do
        expect(hand(a_straight).straight.tiebreaker).to eq(CardValue::SIX)
      end

      it "returns nil if a hand is not a straight" do
        nearly_a_straight = "2H 5D AS 3C 4D"
      
        expect(hand(nearly_a_straight).straight).to eq(nil)
      end
    end
    
    describe "flush" do
      it "returns details if hand is a flush" do
        expect(hand(a_flush).flush.tiebreaker).to eq(CardValue::ACE)
      end

      it "returns nil if a hand is not a flush" do
        nearly_a_flush = "2H 5H AH 3C 9H"
      
        expect(hand(nearly_a_flush).flush).to eq(nil)
      end
    end
  
    describe "full_house" do
      it "returns details if hand contains a full house" do
        # Note that first tiebreaker (value of triple) will always break the tie, unless there is
        # more than one deck, so having value of pair as second tiebreaker is redundant
        expect(hand(a_full_house).full_house.tiebreaker).to eq([CardValue::THREE, CardValue::TWO])
      end

      it "returns nil if a hand does not contain a full house" do
        expect(hand(two_pairs).full_house).to eq(nil)
      end
    end
    
    describe "four_of_a_kind" do
      it "returns details if hand contains four of a kind" do
        expect(hand(four_kings).four_of_a_kind.tiebreaker).to eq(CardValue::KING)
      end

      it "returns nil if a hand does not contain four of a kind" do
        expect(hand(two_pairs).four_of_a_kind).to eq(nil)
      end
    end
    
    describe "straight flush" do
      it "returns details if hand is a straight flush" do
        expect(hand(a_straight_flush).straight_flush.tiebreaker).to eq([CardValue::SIX, CardValue::SIX])
      end
     
      it "returns nil if a hand is not a straight flush" do
        nearly_a_straight_flush = "2H 5H 4H 3H 6S"

        expect(hand(nearly_a_straight_flush).straight_flush).to eq(nil)
      end
    end
  end
end
