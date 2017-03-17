require 'zones'
require 'zone'

# DeviceZoneMapper
class DeviceZoneMapper
  def initialize(devices)
    @devices = devices
    @root_zones = nil
  end

  def organise
    construct_zone_tree if @root_zones.nil?
    @root_zones.to_hash
  end

  private

  def construct_zone_tree
    @root_zones = Zones.new
    @devices.each do |device|
      device.each do |device_name, zone_path|
        add_device(device_name, zone_path)
      end
    end
  end

  def add_device(device_name, zone_path)
    full_zone_path = construct_full_zone_path(zone_path)

    insertion_point = find_insertion_point(full_zone_path)

    return insertion_point.add_device(device_name) if
      insertion_point.name == full_zone_path.last

    add_new_zones_and_device(full_zone_path, device_name, insertion_point)
  end

  def construct_full_zone_path(zone_path)
    full_zone_path = zone_path.split(',')

    raise 'No zones found: devices are unallocated' if full_zone_path.empty?

    full_zone_path
  end

  def find_insertion_point(zone_path)
    @root_zones.find_insertion_point(zone_path) || @root_zones
  end

  def add_new_zones_and_device(full_zone_path, device_name, insertion_point)
    remaining_zone_path =
      calculate_remaining_zone_path(full_zone_path, insertion_point.name)

    zone_root = create_remaining_zones(remaining_zone_path, device_name)[0]

    insertion_point.add_zone(zone_root)
  end

  def calculate_remaining_zone_path(full_zone_path, insertion_point_name)
    if full_zone_path.include?(insertion_point_name)
      full_zone_path.slice(
        (full_zone_path.find_index(insertion_point_name) + 1)..-1
      )
    else
      full_zone_path
    end
  end

  def create_remaining_zones(remaining_zone_path, device_name)
    zones = remaining_zone_path.map do |zone_name|
      Zone.new(zone_name)
    end

    zones.each_cons(2) do |z1, z2|
      z1.add_zone(z2)
    end

    zones.last.add_device(device_name)

    zones
  end
end
