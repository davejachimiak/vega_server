require 'vega_server/outgoing_messages'
require 'vega_server/meddleable'

module VegaServer::IncomingMessages
  class Call
    include VegaServer::Meddleable

    def initialize(websocket, payload)
      @websocket       = websocket
      @payload         = payload
      @room_id         = payload[:room_id]
      @client_id       = pool.add!(@websocket)
    end

    def handle
      VegaServer::OutgoingMessages.send_message(@websocket, message)
      add_client_to_room
    end

    private

    def message
      VegaServer::OutgoingMessages::CallAccepted.new(peer_ids)
    end

    def peer_ids
      room.reject { |client_id| client_id == @client_id }
    end

    def room
      @room ||= storage.room(@room_id)
    end

    def add_client_to_room
      storage.add_to_room(@client_id, @payload)
    end
  end
end
