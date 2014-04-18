require 'vega_server/outgoing_messages'

module VegaServer::IncomingMessages
  class Call
    def initialize(websocket, payload)
      @websocket       = websocket
      @payload         = payload
      @room_id         = payload[:room_id]
      @pool            = VegaServer.connection_pool
      @storage         = VegaServer.storage
      @room_capacities = VegaServer.room_capacities
      @client_id       = @pool.add!(@websocket)
    end

    def handle
      VegaServer::OutgoingMessages.send_message(@websocket, message)
      add_client_to_room unless room_at_capacity?
    end

    def self.handle(websocket, payload)
      new(websocket, payload).handle
    end

    private

    def message
      if room_at_capacity?
        VegaServer::OutgoingMessages::RoomFullError.new
      elsif room_is_empty?
        VegaServer::OutgoingMessages::CallerSuccess.new
      else
        VegaServer::OutgoingMessages::CalleeSuccess.new
      end
    end

    def room_at_capacity?
      return false if @room_capacities.empty?

      @room_capacities.any? do |capacity|
        capacity.first == room_path && capacity.last == room.size
      end
    end

    def room_path
      @room_id.match(/(\/.*)\/.*$/)[1]
    end

    def room_is_empty?
      @room_is_empty ||= @storage.room_is_empty?(@room_id)
    end

    def room
      @room ||= @storage.room(@room_id)
    end

    def add_client_to_room
      @storage.add_to_room(@client_id, @payload)
    end
  end
end
