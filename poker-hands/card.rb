require_relative "card_value"

class Card
  include Comparable
  include CardValue

  attr_reader :suit
  attr_reader :value

  COMPARABLE_VALUE = { "2" => CardValue::TWO,   "3" => CardValue::THREE,  "4" => CardValue::FOUR,
                       "5" => CardValue::FIVE,  "6" => CardValue::SIX,    "7" => CardValue::SEVEN,
                       "8" => CardValue::EIGHT, "9" => CardValue::NINE,  "10" => CardValue::TEN,
                       "J" => CardValue::JACK,  "Q" => CardValue::QUEEN,  "K" => CardValue::KING, 
                       "A" => CardValue::ACE
  }
  
  def initialize(card)
    @printable_value = card[0..-2]
    @value = COMPARABLE_VALUE[@printable_value]
    @suit = card[card.length-1]
  end

  def to_s
    "#{@printable_value}#{@suit}"
  end

  def compare_value(other)
    self.value <=> other.value
  end

  def <=>(other)
    compare_value(other).nonzero? || self.suit <=> other.suit
  end
end
