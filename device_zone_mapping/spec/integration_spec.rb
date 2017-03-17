require 'spec_helper'
require 'device_zone_mapper'
require 'zones'
require 'zone'

describe DeviceZoneMapper do
  subject { described_class.new input }

  context 'with an empty array' do
    let(:input) { [] }

    it 'returns an empty hash' do
      expect(subject.organise).to eq({})
    end
  end

  context 'with hosts that do not specify zones' do
    let(:input) do
      [{ "host_1": '' }, { "host_2": '' }]
    end

    it 'throws exception as input is invalid' do
      expect { subject.organise }.to raise_error(
        RuntimeError, 'No zones found: devices are unallocated'
      )
    end
  end

  context 'with a device in the top level zone' do
    let(:input) { [{ 'host_1' => 'zone_a' }] }

    it 'returns the device in the zone hash' do
      expect(subject.organise).to eq(
        'zone_a' => { 'devices' => ['host_1'] }
      )
    end
  end

  context 'with a device nested within two zones' do
    let(:input) { [{ 'host_1' => 'zone_a,zone_b' }] }

    it 'returns the devices nested in two zones' do
      expect(subject.organise).to eq(
        'zone_a' => { 'zone_b' => { 'devices' => ['host_1'] } }
      )
    end
  end

  context 'with multiple devices in a top level zone' do
    let(:input) { [{ 'host_1' => 'zone_a' }, { 'host_2' => 'zone_a' }] }

    it 'returns the devices in the zone hash' do
      expect(subject.organise).to eq(
        'zone_a' => { 'devices' => %w(host_1 host_2) }
      )
    end
  end

  context 'with multiple devices in different top level zones' do
    let(:input) { [{ 'host_1' => 'zone_a' }, { 'host_2' => 'zone_b' }] }

    it 'returns the devices in the zone hash' do
      expect(subject.organise).to eq('zone_a' => { 'devices' => ['host_1'] },
                                     'zone_b' => { 'devices' => ['host_2'] })
    end
  end

  context 'with two devices nested into the same zone chain level' do
    let(:input) do
      [
        { 'host_1' => 'zone_a,zone_b,zone_e' },
        { 'host_2' => 'zone_a,zone_b,zone_e' }
      ]
    end

    it 'places devices of common sub zones into the same inner zone hash' do
      expect(subject.organise).to eq(
        'zone_a' => {
          'zone_b' => {
            'zone_e' => {
              'devices' => %w(host_1 host_2)
            }
          }
        }
      )
    end
  end

  context 'with devices in similar but differently deep zone chain levels' do
    let(:input) do
      [
        { 'host_2' => 'zone_a,zone_b' },
        { 'host_1' => 'zone_a,zone_b,zone_e' }
      ]
    end

    it 'nests devices from different subzones in the same parent zone into\
          a nested hash array' do
      expect(subject.organise).to eq(
        'zone_a' => {
          'zone_b' => [
            { 'devices' => ['host_2'] },
            { 'zone_e' => { 'devices' => ['host_1'] } }
          ]
        }
      )
    end
  end

  context 'with zone with two child zones' do
    let(:input) do
      [
        { 'host_1' => 'zone_a,zone_b,zone_c' },
        { 'host_2' => 'zone_a,zone_b,zone_d' }
      ]
    end

    it 'places zones with common parent in same parent zone' do
      expect(subject.organise).to eq(
        'zone_a' => {
          'zone_b' => {
            'zone_c' => {
              'devices' => ['host_1']
            },
            'zone_d' => {
              'devices' => ['host_2']
            }
          }
        }
      )
    end
  end

  context 'with zone with a device and two child zones ' do
    let(:input) do
      [
        { 'host_1' => 'zone_a,zone_b,zone_c' },
        { 'host_2' => 'zone_a,zone_b,zone_d' },
        { 'host_3' => 'zone_a,zone_b' }
      ]
    end

    it 'places zones with common parent in same parent zone and \
          parent zone has device' do
      expect(subject.organise).to eq(
        'zone_a' => {
          'zone_b' => [
            { 'devices' => ['host_3'] },
            {
              'zone_c' => {
                'devices' => ['host_1']
              },
              'zone_d' => {
                'devices' => ['host_2']
              }
            }
          ]
        }
      )
    end
  end

  context 'with devices in separate zone chains, common zone chains & similar\
             but differently deep zone chains' do
    let(:input) do
      [
        { 'host_1' => 'zone_a,zone_b,zone_c' },
        { 'host_2' => 'zone_a,zone_b,zone_c,zone_d' },
        { 'host_3' => 'zone_a,zone_b,zone_c,zone_d' },
        { 'host_4' => 'zone_x,zone_y' }
      ]
    end
    it 'nests devices and subzones of arbitrary complexity into the right zone\
          chains of the zone tree' do
      expect(subject.organise).to eq(
        'zone_a' => {
          'zone_b' => {
            'zone_c' => [
              { 'devices' => ['host_1'] },
              {
                'zone_d' => {
                  'devices' => %w(host_2 host_3)
                }
              }
            ]
          }
        },
        'zone_x' => {
          'zone_y' => {
            'devices' => ['host_4']
          }
        }
      )
    end
  end
end
