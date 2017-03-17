require 'zone'

# Zones
class Zones
  attr_reader :name

  def initialize(zones = [])
    @zones = zones
    @name = 'zones'
  end

  def empty?
    @zones.empty?
  end

  def to_hash
    @zones.map(&:to_hash).inject({}) { |a, e| a.merge!(e) }
  end

  def find_insertion_point(path)
    index = @zones.index(Zone.new(path[0]))

    return nil if index.nil?

    return @zones[index] if path.length == 1

    insertion_point = @zones[index].find_insertion_point(path.drop(1))

    insertion_point || @zones[index]
  end

  def add_zone(zone)
    @zones.push(zone)
  end
end
