require_relative "card"
require_relative "poker_rank"

class Hand
  include Comparable

  class HandRank < Struct.new(:rank, :tiebreaker, :remaining_cards)
    include Comparable

    def <=>(other)
      rank_diff = rank - other.rank
      
      return (rank_diff / rank_diff.abs) unless (rank_diff == 0)
      
      evaluate_tiebreaker(other)
    end

    private def evaluate_tiebreaker(other)
      tiebreak = if tiebreaker.nil? then 0 else (tiebreaker <=> other.tiebreaker) end
      
      return tiebreak unless (tiebreak == 0)

      highest_card_wins(other)
    end

    private def highest_card_wins(other)
      card_comparisons = remaining_cards.zip(other.remaining_cards).map {
        |card, other_card| card.compare_value(other_card) 
      }.select { |x| x != 0 }
      
      if card_comparisons.empty? then 0 else card_comparisons[0] end
    end
  end

  # Main body begins
  
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

    if (tmp = three_of_a_kind)
      best_rank = tmp
    elsif (tmp = two_pair)
      best_rank = tmp
    elsif (tmp = pair)
      best_rank = tmp 
    end

    best_rank
  end

  def pair
    find_pair(@cards)
  end

  def two_pair
    higher_pair = find_pair(@cards)

    if (higher_pair)
      lower_pair = find_pair(higher_pair.remaining_cards)
      if (lower_pair)
        tiebreaker = [higher_pair.tiebreaker, lower_pair.tiebreaker]
        return HandRank.new(PokerRank::TWO_PAIRS, tiebreaker, lower_pair.remaining_cards)
      end
    end
  end
  
  def three_of_a_kind
    cards.each_cons(3) { |card_1, card_2, card_3|
      if ((card_1.value == card_2.value) && (card_2.value == card_3.value))
        tiebreaker = card_1.value
        remaining_cards = cards.select { |c| c.value != card_1.value }

        break HandRank.new(PokerRank::THREE_OF_A_KIND, tiebreaker, remaining_cards)
      end
    }
  end
  
  private
  
  def find_pair(cards)
    cards.each_cons(2) { |card_1, card_2|
      if (card_1.value == card_2.value)
        tiebreaker = card_1.value
        remaining_cards = cards.select { |c| c.value != card_1.value }

        break HandRank.new(PokerRank::A_PAIR, tiebreaker, remaining_cards)
      end
    }
  end
end
