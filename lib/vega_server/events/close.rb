require 'vega_server/outgoing_messages/unexpected_peer_hang_up'

module VegaServer::Events
  class Close
    def initialize(websocket)
      @websocket = websocket
      @pool      = VegaServer.connection_pool
    end

    def handle
      room_peer_websockets.each do |websocket|
        VegaServer::OutgoingMessages.send_message(websocket, message)
      end
    end

    def self.handle(websocket, event)
      new(websocket).handle
    end

    private

    def room_peer_websockets
      room = storage.client_room(client_id)

      if room
        client_ids = room.reject do |key|
          key == client_id
        end

        client_ids.map { |id| @pool[id] }
      else
        []
      end
    end

    def storage
      VegaServer.storage
    end

    def client_id
      @pool.inverted_pool[@websocket]
    end

    def message
      VegaServer::OutgoingMessages::UnexpectedPeerHangUp.new(client_id)
    end
  end
end
