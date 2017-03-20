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
      [
        Zone.new(
          'zone_a',
          [],
          [
            Zone.new(
              'zone_b',
              ['host_3'],
              [
                Zone.new('zone_c', ['host_1'], []),
                Zone.new('zone_d', ['host_2'], [])
              ]
            )
          ]
        )
      ]
    end

    it 'inserts device into existing zone_a for path [zone_a]' do
      output = Zones.new(
        [
          Zone.new(
            'zone_a',
            ['new device'],
            [
              Zone.new(
                'zone_b',
                ['host_3'],
                [
                  Zone.new('zone_c', ['host_1'], []),
                  Zone.new('zone_d', ['host_2'], [])
                ]
              )
            ]
          )
        ]
      )

      subject.add_device('new device', %w(zone_a))
      expect(subject).to eq(output)
    end

    it 'inserts device into existing zone_b for path [zone_a, zone_b]' do
      output = Zones.new(
        [
          Zone.new(
            'zone_a',
            [],
            [
              Zone.new(
                'zone_b',
                ['host_3', 'new device'],
                [
                  Zone.new('zone_c', ['host_1'], []),
                  Zone.new('zone_d', ['host_2'], [])
                ]
              )
            ]
          )
        ]
      )

      subject.add_device('new device', %w(zone_a zone_b))
      expect(subject).to eq(output)
    end

    it 'adds new zone_e to zone_a for path [zone_a, zone_e]' do
      output = Zones.new(
        [
          Zone.new(
            'zone_a',
            [],
            [
              Zone.new(
                'zone_b',
                ['host_3'],
                [
                  Zone.new('zone_c', ['host_1'], []),
                  Zone.new('zone_d', ['host_2'], [])
                ]
              ),
              Zone.new(
                'zone_e',
                ['new device'],
                []
              )
            ]
          )
        ]
      )

      subject.add_device('new device', %w(zone_a zone_e))
      expect(subject).to eq(output)
    end

    it 'adds new zones zone_e and zone_f to zone_a for path \
    [zone_a, zone_e, zone_f]' do
      output = Zones.new(
        [
          Zone.new(
            'zone_a',
            [],
            [
              Zone.new(
                'zone_b',
                ['host_3'],
                [
                  Zone.new('zone_c', ['host_1'], []),
                  Zone.new('zone_d', ['host_2'], [])
                ]
              ),
              Zone.new(
                'zone_e',
                [],
                [
                  Zone.new(
                    'zone_f',
                    ['new device'],
                    []
                  )
                ]
              )
            ]
          )
        ]
      )

      subject.add_device('new device', %w(zone_a zone_e zone_f))
      expect(subject).to eq(output)
    end

    it 'adds new zone_f to zone_b for path [zone_a, zone_b, zone_f]' do
      output = Zones.new(
        [
          Zone.new(
            'zone_a',
            [],
            [
              Zone.new(
                'zone_b',
                ['host_3'],
                [
                  Zone.new('zone_c', ['host_1'], []),
                  Zone.new('zone_d', ['host_2'], []),
                  Zone.new('zone_f', ['new device'], [])
                ]
              )
            ]
          )
        ]
      )

      subject.add_device('new device', %w(zone_a zone_b zone_f))
      expect(subject).to eq(output)
    end

    it 'adds new root zone_z for path [zone_z]' do
      output = Zones.new(
        [
          Zone.new(
            'zone_a',
            [],
            [
              Zone.new(
                'zone_b',
                ['host_3'],
                [
                  Zone.new('zone_c', ['host_1'], []),
                  Zone.new('zone_d', ['host_2'], [])
                ]
              )
            ]
          ),
          Zone.new(
            'zone_z',
            [],
            [
              Zone.new(
                'zone_y',
                ['new device'],
                []
              )
            ]
          )
        ]
      )

      subject.add_device('new device', %w(zone_z zone_y))
      expect(subject).to eq(output)
    end
  end
end
