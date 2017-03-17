require 'spec_helper'
require 'zones'
require 'zone'

describe Zones do
  subject { described_class.new input }
  context 'with two devices nested into the same zone chain level\
           zone_a => {                                           \
             zone_b => {                                         \
               devices => [host_3],                              \
               zone_c => {                                       \
                 devices => [host_1]                             \
               },                                                \
               zone_d => {                                       \
                 devices => [host_2]                             \
               }                                                 \
             }                                                   \
           }                                                     \
  ' do

    let(:input) do
      zone_d = Zone.new('zone_d', [],               ['host_2'])
      zone_c = Zone.new('zone_c', [],               ['host_1'])
      zone_b = Zone.new('zone_b', [zone_c, zone_d], ['host_3'])
      zone_a = Zone.new('zone_a', [zone_b],         [])

      [zone_a]
    end

    it 'returns insertion point of zone_a for path [zone_a]' do
      expect(subject.find_insertion_point(%w(zone_a)).name).to eq('zone_a')
    end

    it 'returns insertion point for zone_b for path [zone_a, zone_b]' do
      expect(
        subject.find_insertion_point(%w(zone_a zone_b)).name
      ).to eq('zone_b')
    end

    it 'returns insertion point of zone_d for path [zone_a, zone_b, zone_d]' do
      expect(
        subject.find_insertion_point(%w(zone_a zone_b zone_d)).name
      ).to eq('zone_d')
    end

    it 'returns insertion point of zone_a for path [zone_a, zone_e]' do
      expect(
        subject.find_insertion_point(%w(zone_a zone_e)).name
      ).to eq('zone_a')
    end

    it 'returns insertion point of zone_b for path [zone_a, zone_b, zone_f]' do
      expect(
        subject.find_insertion_point(%w(zone_a zone_b zone_f)).name
      ).to eq('zone_b')
    end

    it 'returns insertion point of zone_d for path \
          [zone_a, zone_b, zone_d, zone_e]' do
      expect(
        subject.find_insertion_point(%w(zone_a zone_b zone_d zone_e)).name
      ).to eq('zone_d')
    end

    it 'returns no insertion point for path [zone_z]' do
      expect(
        subject.find_insertion_point(['zone_z']).nil?
      ).to eq(true)
    end
  end
end
