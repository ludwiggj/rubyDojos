require_relative 'card'
require_relative 'poker_rank'

# Hand representation
class Hand
  include Comparable

  # Hand rank representation
  class HandRank
    include Comparable

    attr_reader :rank, :tiebreaker, :remaining_cards

    def initialize(rank, tiebreaker, remaining_cards)
      @rank = rank
      @tiebreaker = tiebreaker
      @remaining_cards = remaining_cards
    end

    def <=>(other)
      rank_diff = @rank - other.rank

      if rank_diff != 0
        (rank_diff / rank_diff.abs)
      else
        evaluate_tiebreaker(other)
      end
    end

    def to_s
      "Rank: [#{@rank}], Tiebreaker: [#{@tiebreaker}], " \
        "Remaining Cards: #{@remaining_cards}"
    end

    def use_first_tiebreaker
      @tiebreaker = @tiebreaker.first
      self
    end

    private

    def evaluate_tiebreaker(other)
      tiebreak = (@tiebreaker <=> other.tiebreaker)

      if tiebreak != 0
        tiebreak
      else
        highest_card_wins(other)
      end
    end

    def highest_card_wins(other)
      card_comparisons = @remaining_cards.zip(other.remaining_cards)
                                         .map { |c1, c2| c1.compare_value(c2) }
                                         .select { |x| x != 0 }

      if card_comparisons.empty?
        0
      else
        card_comparisons[0]
      end
    end
  end

  # Main body begins

  attr_reader :cards

  def initialize(cards)
    @cards = cards.split(' ').map { |c| Card.new(c) }.sort.reverse
    reset_remaining_cards
  end

  def reset_remaining_cards
    @remaining_cards = @cards
    nil
  end

  def to_s
    @cards.map(&:to_s)
  end

  def <=>(other)
    rank <=> other.rank
  end

  def rank
    reset_remaining_cards

    straight_flush || four_of_a_kind || full_house || flush || straight ||
      three_of_a_kind || two_pairs || a_pair || highest_card
  end

  def straight_flush
    # Note that first tiebreaker (highest card) will always break the tie,
    # unless there is so having value as second tiebreaker is redundant
    two_matches(
      PokerRank::A_STRAIGHT_FLUSH, -> { straight }, -> { flush }
    )&.use_first_tiebreaker
  end

  def four_of_a_kind
    n_of_a_kind(4, PokerRank::FOUR_OF_A_KIND)
  end

  def full_house
    # Note that first tiebreaker (value of triple) will always break the tie,
    # unless there is more than one deck, so having value of pair as second
    # tiebreaker is redundant
    two_matches(
      PokerRank::FULL_HOUSE, -> { three_of_a_kind }, -> { a_pair }
    )&.use_first_tiebreaker
  end

  def flush
    return unless all_equal?(@remaining_cards.map(&:suit))

    tiebreaker_value = @remaining_cards[0].value
    @remaining_cards = []
    HandRank.new(PokerRank::A_FLUSH, tiebreaker_value, [])
  end

  def straight
    return unless @remaining_cards.each_cons(2).all? do |c1, c2|
      c1.value == c2.value + 1
    end

    tiebreaker_value = @remaining_cards[0].value
    HandRank.new(PokerRank::A_STRAIGHT, tiebreaker_value, [])
  end

  def three_of_a_kind
    n_of_a_kind(3, PokerRank::THREE_OF_A_KIND)
  end

  def two_pairs
    two_matches(PokerRank::TWO_PAIRS, -> { a_pair }, -> { a_pair })
  end

  def a_pair
    n_of_a_kind(2, PokerRank::A_PAIR)
  end

  def highest_card
    tiebreaker_value = @remaining_cards[0].value
    @remaining_cards = @remaining_cards.drop(1)
    HandRank.new(PokerRank::HIGHEST_CARD, tiebreaker_value, @remaining_cards)
  end

  private

  def n_of_a_kind(n, rank)
    @remaining_cards.each_cons(n) do |n_cards|
      next unless all_equal?(n_cards.map(&:value))

      tiebreaker_value = n_cards[0].value

      # Remove matched cards from remaining cards
      @remaining_cards = @remaining_cards.select do |c|
        c.value != tiebreaker_value
      end

      break HandRank.new(rank, tiebreaker_value, @remaining_cards)
    end
  end

  def two_matches(rank, first_criteria, second_criteria)
    hand_rank = lambda do
      first_match = first_criteria.call
      return unless first_match

      second_match = second_criteria.call
      return unless second_match

      tiebreaker = [first_match.tiebreaker, second_match.tiebreaker]
      HandRank.new(rank, tiebreaker, @remaining_cards)
    end

    hand_rank.call || reset_remaining_cards
  end

  def all_equal?(array)
    array.max == array.min
  end
end
