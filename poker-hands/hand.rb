require_relative "card"
require_relative "poker_rank"

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
  
  def tiebreaker(rank1, rank2)
    if rank1.tiebreaker.nil?
      0
    else
      rank1.tiebreaker <=> rank2.tiebreaker
    end
  end

  def <=>(other)
    my_rank = rank
    other_rank = other.rank

    rank_diff = my_rank.value - other_rank.value

    if (rank_diff == 0)
      tiebreak_result = tiebreaker(my_rank, other_rank)

      if (tiebreak_result == 0)
        result = my_rank.remaining_cards.zip(other_rank.remaining_cards).map { |a, b| a <=> b }.select { |x| x != 0 }
        if result.empty?
          0
        else
          result[0]
        end
      else
        tiebreak_result
      end
    else
      rank_diff / rank_diff.abs
    end 
  end

  HandRank = Struct.new(:value, :tiebreaker, :remaining_cards)

  def rank
    best_rank = HandRank.new(PokerRank::HIGHEST_CARD, nil, @cards)

    if (tmp = pair)
      best_rank = tmp 
    end

    best_rank
  end

  def pair
    @cards.each_cons(2) { |card|
      if (card[0] == card[1])
        pair_value = card[0].value
        remaining_cards = @cards.select { |c| c.value != pair_value }

        break HandRank.new(PokerRank::A_PAIR, pair_value, remaining_cards)
      end
    }
  end
end
