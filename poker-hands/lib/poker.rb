require 'hand'

# Represent a poker game
class Poker
  def winner(hand1, hand2)
    h1 = Hand.new(hand1)
    h2 = Hand.new(hand2)

    case h2 <=> h1
    when 0
      :draw
    when 1
      :hand2
    else
      :hand1
    end
  end
end
