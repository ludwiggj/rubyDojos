require 'zones'
require 'zone'

# DeviceZoneMapper
class DeviceZoneMapper
  def initialize(devices)
    @devices = devices
    @root = nil
  end

  def organise
    @root = Zone.build(@devices) if @root.nil?
    @root.to_hash
  end
end
