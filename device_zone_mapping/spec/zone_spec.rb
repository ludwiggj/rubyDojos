require 'spec_helper'
require 'zones'
require 'zone'

describe Zone do
  ZONE_A = 'zone_a'.freeze
  ZONE_B = 'zone_b'.freeze
  ZONE_C = 'zone_c'.freeze
  ZONE_D = 'zone_d'.freeze
  ZONE_E = 'zone_e'.freeze
  ZONE_F = 'zone_f'.freeze

  DEVICE_A = 'device_a'.freeze
  DEVICE_B = 'device_b'.freeze
  DEVICE_C = 'device_c'.freeze

  let(:zone_a_leaf) do
    Zone.new(ZONE_A)
  end
  let(:zone_b_leaf) do
    Zone.new(ZONE_B)
  end
  let(:zone_c_leaf) do
    Zone.new(ZONE_C)
  end
  let(:zone_d_leaf) do
    Zone.new(ZONE_D)
  end
  let(:zone_e_leaf) do
    Zone.new(ZONE_E)
  end
  let(:zone_f_leaf) do
    Zone.new(ZONE_F)
  end
  let(:zone_a_with_child_zone_b) do
    Zone.new(ZONE_A, [], [:zone_b_leaf])
  end
  let(:zone_b_with_child_zone_a) do
    Zone.new(ZONE_B, [], [:zone_a_leaf])
  end
  let(:zone_b_with_child_zone_c) do
    Zone.new(ZONE_B, [], [:zone_c_leaf])
  end
  let(:zone_b_with_child_zones_a_c) do
    Zone.new(ZONE_B, [], [:zone_a_leaf, :zone_c_leaf])
  end
  let(:zone_b_with_child_zones_a_c_e) do
    Zone.new(ZONE_B, [], [:zone_a_leaf, :zone_c_leaf, :zone_e_leaf])
  end
  let(:zone_b_with_child_zones_c_d) do
    Zone.new(ZONE_B, [], [:zone_c_leaf, :zone_d_leaf])
  end
  let(:zone_b_with_child_zones_c_d_e) do
    Zone.new(ZONE_B, [], [:zone_c_leaf, :zone_d_leaf, :zone_e_leaf])
  end
  let(:zone_b_with_child_zones_c_d_f) do
    Zone.new(ZONE_B, [], [:zone_c_leaf, :zone_d_leaf, :zone_f_leaf])
  end
  let(:zone_b_with_device_a) do
    Zone.new(ZONE_B, [DEVICE_A])
  end
  let(:zone_b_with_devices_a_b) do
    Zone.new(ZONE_B, [DEVICE_A, DEVICE_B])
  end
  let(:zone_b_with_devices_a_c) do
    Zone.new(ZONE_B, [DEVICE_A, DEVICE_C])
  end
  let(:zone_b_with_device_a_and_child_zone_c) do
    Zone.new(ZONE_B, [DEVICE_A], [:zone_c_leaf])
  end
  let(:zone_b_with_device_b_and_child_zone_a) do
    Zone.new(ZONE_B, [DEVICE_B], [:zone_a_leaf])
  end
  let(:zone_b_with_device_b_and_child_zone_b) do
    Zone.new(ZONE_B, [DEVICE_B], [:zone_b_leaf])
  end

  context 'zones are compared on zone name first' do
    it 'zone_b_leaf > zone_a_leaf' do
      expect(zone_b_leaf > zone_a_leaf).to eq(true)
    end

    it 'zone_b_leaf > zone_a_with_child_zone_b' do
      expect(zone_b_leaf > zone_a_with_child_zone_b).to eq(true)
    end

    it 'zone_b_leaf == zone_b_leaf' do
      expect(zone_b_leaf == Zone.new('zone_b')).to eq(true)
    end

    it 'zone_b_leaf < zone_c_leaf' do
      expect(zone_b_leaf < zone_c_leaf).to eq(true)
    end
  end

  context 'zones are compared on devices after zone name' do
    it 'zone_b_leaf < zone_b_with_device_a' do
      expect(zone_b_leaf < zone_b_with_device_a).to eq(true)
    end

    it 'zone_b_with_device_a < zone_b_with_devices_a_b' do
      expect(zone_b_with_device_a < zone_b_with_devices_a_b).to eq(true)
    end

    it 'zone_b_with_devices_a_b == zone_b_with_devices_a_b' do
      expect(
        zone_b_with_devices_a_b == Zone.new(ZONE_B, [DEVICE_A, DEVICE_B])
      ).to eq(true)
    end

    it 'zone_b_with_devices_a_b < zone_b_with_devices_a_c' do
      expect(zone_b_with_devices_a_b < zone_b_with_devices_a_c).to eq(true)
    end

    it 'zone_b_with_device_a_and_child_zone_c < \
    zone_b_with_device_b_and_child_zone_a' do
      expect(
        zone_b_with_device_a_and_child_zone_c <
          zone_b_with_device_b_and_child_zone_a
      ).to eq(true)
    end
  end

  context 'zones are compared on child zones after zone name' do
    it 'zone_b_leaf < zone_b_with_child_zone_a' do
      expect(zone_b_leaf < zone_b_with_child_zone_a).to eq(true)
    end

    it 'zone_b_with_device_b_and_child_zone_a < \
    zone_b_with_device_b_and_child_zone_b' do
      expect(
        zone_b_with_device_b_and_child_zone_a <
          zone_b_with_device_b_and_child_zone_b
      ).to eq(true)
    end

    it '(zone_b_with_device_a < zone_b_with_device_a_and_child_zone_c' do
      expect(
        zone_b_with_device_a < zone_b_with_device_a_and_child_zone_c
      ).to eq(true)
    end

    it 'zone_b_with_child_zone_a < zone_b_with_child_zone_c' do
      expect(zone_b_with_child_zone_a < zone_b_with_child_zone_c).to eq(true)
    end

    it 'zone_b_with_child_zone_a < zone_b_with_child_zones_a_c' do
      expect(
        zone_b_with_child_zone_a < zone_b_with_child_zones_a_c
      ).to eq(true)
    end

    it 'zone_b_with_child_zones_a_c == zone_b_with_child_zones_a_c' do
      expect(
        zone_b_with_child_zones_a_c ==
          Zone.new(ZONE_B, [], [:zone_a_leaf, :zone_c_leaf])
      ).to eq(true)
    end

    it 'zone_b_with_child_zones_a_c < zone_b_with_child_zones_a_c_e' do
      expect(
        zone_b_with_child_zones_a_c <
          zone_b_with_child_zones_a_c_e
      ).to eq(true)
    end

    it 'zone_b_with_child_zone_c < zone_b_with_child_zones_c_d' do
      expect(
        zone_b_with_child_zone_c < zone_b_with_child_zones_c_d
      ).to eq(true)
    end

    it 'zone_b_with_child_zones_c_d < zone_b_with_child_zones_c_d_e' do
      expect(
        zone_b_with_child_zones_c_d < zone_b_with_child_zones_c_d_e
      ).to eq(true)
    end

    it 'zone_b_with_child_zones_c_d_e < zone_b_with_child_zones_c_d_f' do
      expect(
        zone_b_with_child_zones_c_d_e < zone_b_with_child_zones_c_d_f
      ).to eq(true)
    end
  end
end
