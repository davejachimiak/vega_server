require 'vega_server/outgoing_messages'
require 'vega_server/meddleable'

module VegaServer::IncomingMessages
  class Call
    include VegaServer::Meddleable

    def initialize(websocket, payload)
      @websocket       = websocket
      @payload         = payload
      @room_id         = payload[:room_id]
      @room_capacities = VegaServer.room_capacities
      @client_id       = pool.add!(@websocket)
    end

    def handle
      VegaServer::OutgoingMessages.send_message(@websocket, message)
      add_client_to_room unless room_at_capacity?
    end

    private

    def message
      if room_at_capacity?
        VegaServer::OutgoingMessages::RoomFull.new
      else
        VegaServer::OutgoingMessages::CallAccepted.new(peer_ids)
      end
    end

    def peer_ids
      room.reject { |client_id| client_id == @client_id }
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

    def room
      @room ||= storage.room(@room_id)
    end

    def add_client_to_room
      storage.add_to_room(@client_id, @payload)
    end
  end
end
