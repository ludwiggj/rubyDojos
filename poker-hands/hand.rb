require_relative "card"
require_relative "poker_rank"

class Hand
  include Comparable

  class HandRank < Struct.new(:value, :tiebreaker, :remaining_cards)
    include Comparable

    def evaluate_tiebreaker(other)
      tiebreak = if tiebreaker.nil? then 0 else (tiebreaker <=> other.tiebreaker) end
      
      return tiebreak unless (tiebreak == 0)
      
      card_comparisons = remaining_cards.zip(other.remaining_cards).map { |a, b| a <=> b }.select { |x| x != 0 }
      
      if card_comparisons.empty? then 0 else card_comparisons[0] end
    end

    def <=>(other)
      rank_diff = value - other.value
      
      return (rank_diff / rank_diff.abs) unless (rank_diff == 0)
      
      evaluate_tiebreaker(other)
    end
  end
  
  attr_reader :cards
  
  def initialize(cards)
    @cards = cards.split(' ').map {|c| Card.new(c)}.sort.reverse
  end

  def to_s
    "#{@cards}"
  end

  def <=>(other)
    rank <=> other.rank
  end

  def rank
    best_rank = HandRank.new(PokerRank::HIGHEST_CARD, nil, @cards)

    if (tmp = pair)
      best_rank = tmp 
    end

    best_rank
  end

  def pair
    find_pair(@cards)
  end

  def two_pair
  end
  
  private
  
  def find_pair(cards)
    cards.each_cons(2) { |card_1, card_2|
      if (card_1 == card_2)
        pair_value = card_1.value
        tiebreaker = pair_value
        remaining_cards = cards.select { |c| c.value != pair_value }

        break HandRank.new(PokerRank::A_PAIR, tiebreaker, remaining_cards)
      end
    }
  end
end
