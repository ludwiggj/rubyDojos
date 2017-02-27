require_relative "card_value"

class Card
  include Comparable
  include CardValue
  attr_reader :value

  COMPARABLE_VALUE = { "2" => CardValue::TWO,   "3" => CardValue::THREE,  "4" => CardValue::FOUR,
                       "5" => CardValue::FIVE,  "6" => CardValue::SIX,    "7" => CardValue::SEVEN,
                       "8" => CardValue::EIGHT, "9" => CardValue::NINE,  "10" => CardValue::TEN,
                       "J" => CardValue::JACK,  "Q" => CardValue::QUEEN,  "K" => CardValue::KING, 
                       "A" => CardValue::ACE
  }
  
  def initialize(card)
    @value = card[0..-2]
    @suit = card[card.length-1]
  end

  def to_s
    "#{@value}#{@suit}"
  end

  def <=>(other)
    COMPARABLE_VALUE[self.value] <=> COMPARABLE_VALUE[other.value]
  end
end
