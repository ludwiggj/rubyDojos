require 'spec_helper'
require 'card'

describe Card do
  def card(cardy_string)
    Card.new(cardy_string)
  end

  describe 'to_s method' do
    it 'returns created cards' do
      expect(card('2H').to_s).to eq('2H')
      expect(card('10D').to_s).to eq('10D')
      expect(card('JD').to_s).to eq('JD')
    end
  end

  describe '< operator' do
    it 'can compare cards' do
      expect(card('2H') < card('3H')).to eq(true)
      expect(card('2H') < card('JH')).to eq(true)
      expect(card('QH') < card('KH')).to eq(true)
      expect(card('10H') < card('AD')).to eq(true)
      expect(card('3H') < card('3S')).to eq(true)
    end
  end

  describe '!= operator' do
    it 'can discriminate cards' do
      expect(card('2H') != card('2C')).to eq(true)
      expect(card('KH') != card('QH')).to eq(true)
    end
  end
end
