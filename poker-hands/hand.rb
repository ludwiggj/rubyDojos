require_relative "card"

class Hand
  
  def initialize(cards)
    @cards = cards.split(' ').map {|c| Card.new(c)}.sort.reverse
  end

  def to_s
    "#{@cards}"
  end

  def highest_card
    @cards[0]
  end
end
