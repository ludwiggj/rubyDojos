require 'zones'

# Zone
class Zone
  include Comparable

  attr_reader :name
  attr_reader :child_zones
  attr_reader :devices

  def initialize(name, child_zones = [], devices = [])
    @name = name
    @child_zones = Zones.new(child_zones)
    @devices = devices
  end

  def to_hash(zone = self)
    return { zone.name => { 'devices' => zone.devices } } if zone.leaf?

    return { zone.name => zone.child_zones.to_hash } if zone.no_devices?

    { zone.name => [{ 'devices' => zone.devices }, zone.child_zones.to_hash] }
  end

  def <=>(other)
    @name <=> other.name
  end

  def find_insertion_point(path)
    @child_zones.find_insertion_point(path)
  end

  def add_zone(zone)
    @child_zones.add_zone(zone)
  end

  def add_device(device)
    @devices.push(device)
  end

  def leaf?
    @child_zones.empty?
  end

  def no_devices?
    @devices.empty?
  end
end
