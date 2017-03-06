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
    @pair_lambda = lambda { |cardz| a_pair(cardz) }
  end

  def to_s
    "#{@cards}"
  end

  def <=>(other)
    rank <=> other.rank
  end

  def rank
    full_house || flush || straight || four_of_a_kind || three_of_a_kind || two_pair || pair || highest_card
  end

  def highest_card
    HandRank.new(PokerRank::HIGHEST_CARD, @cards[0].value, @cards.drop(1))
  end

  def pair
    a_pair(@cards)
  end

  def two_pair
    two_matches(PokerRank::TWO_PAIRS, @pair_lambda, @pair_lambda)
  end

  def three_of_a_kind
    n_of_a_kind(3, @cards, PokerRank::THREE_OF_A_KIND)
  end

  def straight
    if @cards.each_cons(2).all? { |c_1, c_2|
      c_1.value == c_2.value + 1
    } then
      tiebreaker_value = @cards[0].value
      remaining_cards = []
      HandRank.new(PokerRank::A_STRAIGHT, tiebreaker_value, remaining_cards)
    end
  end
 
  def flush
    if all_equal?(@cards.map { |c| c.suit }) then
      tiebreaker_value = @cards[0].value
      remaining_cards = @cards.drop(1)
      HandRank.new(PokerRank::A_FLUSH, tiebreaker_value, remaining_cards)
    end
  end

  def full_house
    three_of_a_kind_lambda = lambda { |c| three_of_a_kind }
  
    # Note that first tiebreaker (value of triple) will always break the tie, unless there is
    # more than one deck, so having value of pair as second tiebreaker is redundant
    two_matches(PokerRank::FULL_HOUSE, three_of_a_kind_lambda, @pair_lambda)
  end
  
  def four_of_a_kind
    n_of_a_kind(4, @cards, PokerRank::FOUR_OF_A_KIND)
  end

  private

  def a_pair(cardz)
    n_of_a_kind(2, cardz, PokerRank::A_PAIR)
  end

  def n_of_a_kind(n, cardz, rank)
    cardz.each_cons(n) { |n_cards|
      if all_equal?(n_cards.map { |c| c.value })
        tiebreaker_value = n_cards[0].value
        remaining_cards = cards_minus(tiebreaker_value)

        break HandRank.new(rank, tiebreaker_value, remaining_cards)
      end
    }
  end

  def two_matches(rank, first_criteria, second_criteria)
    first_match = first_criteria.call(@cards)
    if (first_match)
      second_match = second_criteria.call(first_match.remaining_cards)
      if (second_match)
        tiebreaker = [first_match.tiebreaker, second_match.tiebreaker]
        return HandRank.new(rank, tiebreaker, second_match.remaining_cards)
      end
    end
  end

  def cards_minus(value_to_be_removed)
    @cards.select { |c| c.value != value_to_be_removed }
  end

  def all_equal?(array) array.max == array.min end
end
