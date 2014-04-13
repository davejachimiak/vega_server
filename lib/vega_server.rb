require 'vega_server/version'
require 'vega_server/server'
require 'vega_server/adapters'
require 'vega_server/storage'
require 'vega_server/connection_pool'

module VegaServer
  def self.configure
    yield(self)
  end

  def self.allow_origins(origins)
    @allowed_origins = origins
  end

  def self.allowed_origins
    @allowed_origins ||= []
  end

  def self.set_room_capacities(room_capacities)
    @room_capacities = room_capacities
  end

  def self.room_capacities
    @room_capacities ||= {}
  end

  def self.storage
    @storage ||= VegaServer::Storage::Memory
  end

  def self.event_adapter
    @event_adapter ||= VegaServer::Adapters::Event
  end

  def self.enable_modified_event!
    @event_adapter = VegaServer::Adapters::ModifiedEvent
  end

  def self.disable_modified_event!
    @event_adapter = VegaServer::Adapters::Event
  end

  def self.connection_pool
    VegaServer::ConnectionPool
  end
end
