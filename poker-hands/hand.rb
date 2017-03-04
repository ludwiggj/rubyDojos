require_relative "card"
require_relative "poker_rank"

class Hand
  include Comparable

  class HandRank
    include Comparable

    attr_reader :rank, :tiebreaker, :remaining_cards

    def initialize(rank, tiebreaker, remaining_cards)
      @rank = rank
      @tiebreaker = tiebreaker
      @remaining_cards = remaining_cards
    end

    def <=>(other)
      rank_diff = rank - other.rank
      
      if (rank_diff != 0) then
        (rank_diff / rank_diff.abs)
      else 
        evaluate_tiebreaker(other)
      end
    end

    private

    def evaluate_tiebreaker(other)
      tiebreak = (tiebreaker <=> other.tiebreaker)
      
      if (tiebreak != 0) then
        tiebreak
      else
        highest_card_wins(other)
      end
    end

    def highest_card_wins(other)
      card_comparisons = remaining_cards.zip(other.remaining_cards).map {
        |c_1, c_2| c_1.compare_value(c_2) 
      }.select { |x| x != 0 }
      
      if card_comparisons.empty? then
        0
      else
        card_comparisons[0]
      end
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
    straight || four_of_a_kind || three_of_a_kind || two_pair || pair || highest_card
  end

  def highest_card
    HandRank.new(PokerRank::HIGHEST_CARD, cards[0].value, @cards.drop(1))
  end

  def pair
    a_pair(@cards)
  end

  def two_pair
    higher_pair = a_pair(@cards)

    if (higher_pair)
      lower_pair = a_pair(higher_pair.remaining_cards)
      if (lower_pair)
        tiebreaker = [higher_pair.tiebreaker, lower_pair.tiebreaker]
        return HandRank.new(PokerRank::TWO_PAIRS, tiebreaker, lower_pair.remaining_cards)
      end
    end
  end
  
  def three_of_a_kind
    n_of_a_kind(3, cards, PokerRank::THREE_OF_A_KIND)
  end

  def four_of_a_kind
    n_of_a_kind(4, cards, PokerRank::FOUR_OF_A_KIND)
  end

  def straight
    if cards.each_cons(2).all? { |c_1, c_2|
      c_1.value == c_2.value + 1
    } then
      tiebreaker_value = cards[0].value
      remaining_cards = []
      HandRank.new(PokerRank::A_STRAIGHT, tiebreaker_value, remaining_cards)
    end
  end
  
  private

  def a_pair(cards)
    n_of_a_kind(2, cards, PokerRank::A_PAIR)
  end

  def n_of_a_kind(n, cards, rank)
    cards.each_cons(n) { |cards|
      if all_equal?(cards.map { |c| c.value })
        tiebreaker_value = cards[0].value
        remaining_cards = cards_minus(tiebreaker_value)

        break HandRank.new(rank, tiebreaker_value, remaining_cards)
      end
    }
  end

  def cards_minus(value_to_be_removed)
    cards.select { |c| c.value != value_to_be_removed }
  end

  def all_equal?(array) array.max == array.min end
end
