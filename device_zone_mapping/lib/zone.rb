require 'zones'

# Zone
class Zone
  include Comparable

  attr_reader :name
  attr_reader :devices
  attr_reader :child_zones

  def self.build(devices)
    root = Zones.new

    devices.each do |device_hash|
      device_hash.each do |device, zone_path|
        root.add_device(device, construct_full_zone_path(zone_path))
      end
    end
    root
  end

  def self.construct_full_zone_path(zone_path)
    full_zone_path = zone_path.split(',')
    raise 'No zones found: devices are unallocated' if full_zone_path.empty?
    full_zone_path
  end

  def initialize(name, devices = [], child_zones = [])
    @name = name
    @devices = devices
    @child_zones = Zones.new(child_zones)
  end

  def <=>(other)
    # display_comparison(other)

    (@name <=> other.name).nonzero? ||
      (@devices <=> other.devices).nonzero? ||
      @child_zones <=> other.child_zones
  end

  def to_hash(zone = self)
    return { zone.name => { 'devices' => zone.devices } } if zone.leaf?

    return { zone.name => zone.child_zones.to_hash } if zone.no_devices?

    { zone.name => [{ 'devices' => zone.devices }, zone.child_zones.to_hash] }
  end

  def to_s
    "name: [#{@name}] devices: [#{@devices}] child_zones: [#{@child_zones}]"
  end

  def add_device(device, zone_path = nil)
    if zone_path
      @child_zones.add_device(device, zone_path)
    else
      @devices.push(device)
    end
  end

  def leaf?
    @child_zones.empty?
  end

  def no_devices?
    @devices.empty?
  end

  private

  def display_comparison(other)
    name_comp = @name <=> other.name
    device_comp = @devices <=> other.devices
    child_zone_comp = @child_zones <=> other.child_zones

    puts "Comparing: #{self}"
    puts "       to: #{other}"
    puts "   Result: name: [#{name_comp}] devices: [#{device_comp}] \
child_zones: [#{child_zone_comp}]"
  end
end
