require 'spec_helper'
require 'poker'

describe Poker do
  specify 'two similar crappy hands are equal' do
    hand1 = '2H 4S 6C 8D 10H'
    hand2 = '2S 4C 6D 8H 10S'
    expect(subject.winner(hand1, hand2)).to eq :draw
  end

  specify 'a hand with the highest card wins' do
    hand1 = '2H 4S 6C 8D 10H'
    hand2 = '2S 4C 6D 8H 9S'
    expect(subject.winner(hand1, hand2)).to eq :hand1
  end

  specify 'a hand with the highest card wins' do
    hand1 = '2H 4S 6C 7D 8H'
    hand2 = '2S 4C 6D 7S 9S'
    expect(subject.winner(hand1, hand2)).to eq :hand2
  end

  specify 'falls back when the highest cards are the same' do
    hand1 = '2H 4S 6C 7D 9H'
    hand2 = '2S 4C 6D 8S 9S'
    expect(subject.winner(hand1, hand2)).to eq :hand2
  end

  specify 'falls back when the highest cards are the same' do
    hand1 = '5H 4S 6C 7D 9H'
    hand2 = '2S 3C 4D 8S 9S'
    expect(subject.winner(hand1, hand2)).to eq :hand2
  end

  specify 'a hand with Ace beats a hand without Ace' do
    hand1 = '2H 4S 6C 7D AD'
    hand2 = '2S 4C 6D 8S 9S'
    expect(subject.winner(hand1, hand2)).to eq :hand1
  end

  specify 'a hand with Ace loses to a hand with an Ace and a Jack' do
    hand1 = '2H 4S 6C 7D AD'
    hand2 = '2S 4C 6D JS AS'
    expect(subject.winner(hand1, hand2)).to eq :hand2
  end

  specify 'a hand with Ace/Jack loses to a hand Ace/King' do
    hand1 = '2H 4S 6C KD AD'
    hand2 = '2S 4C 6D JS AS'
    expect(subject.winner(hand1, hand2)).to eq :hand1
  end
end
