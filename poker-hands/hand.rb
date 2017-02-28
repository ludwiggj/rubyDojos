require_relative "card"

class Hand
  include Comparable
  
  attr_reader :cards
  
  def initialize(cards)
    @cards = cards.split(' ').map {|c| Card.new(c)}.sort.reverse
  end

  def to_s
    "#{@cards}"
  end

  # This method may be redundant!
  def highest_card
    @cards[0]
  end
  
  def <=>(other)
    result = self.cards.zip(other.cards).map { |a, b| a <=> b }.select { |x| x != 0 }

    if result.empty?
      0
    else
      result[0]
    end
  end
end
