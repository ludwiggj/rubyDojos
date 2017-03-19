require 'zone'

# Zones
class Zones
  include Comparable

  attr_reader :zones

  def initialize(zones = [])
    @zones = zones
    @name = 'zones'
  end

  def <=>(other)
    @zones <=> other.zones
  end

  def to_hash
    @zones.map(&:to_hash).inject({}) { |a, e| a.merge!(e) }
  end

  def to_s
    @zones.map(&:to_s).join(',')
  end

  def add_device(device, zone_path)
    zone = @zones.find { |z| z.name == zone_path[0] }
    last_zone_in_path = zone_path.length == 1

    if zone
      return zone.add_device(device) if last_zone_in_path
      return zone.add_device(device, zone_path.drop(1))
    end

    return add_zone(Zone.new(zone_path[0], [device], [])) if last_zone_in_path
    add_zone(intermediate_zone(device, zone_path))
  end

  def add_zone(zone)
    @zones.push(zone)
  end

  def empty?
    @zones.empty?
  end

  private

  def intermediate_zone(device, zone_path)
    new_zone = Zone.new(zone_path[0])
    new_zone.add_device(device, zone_path.drop(1))
    new_zone
  end
end
