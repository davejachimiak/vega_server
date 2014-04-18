require 'vega_server/outgoing_messages/peer_hang_up'

module VegaServer::IncomingMessages
  class HangUp
    def initialize(websocket)
      @websocket = websocket
      @pool      = VegaServer.connection_pool
      @storage   = VegaServer.storage
    end

    def handle
      room_peer_websockets.each do |websocket|
        VegaServer::OutgoingMessages.send_message(websocket, message)
      end

      room.delete(client_id)
      @pool.delete(client_id)
      @websocket.close
    end

    def self.handle(websocket)
      new(websocket).handle
    end

    private

    def room_peer_websockets
      room.reject do |key|
        key == client_id
      end.map { |id| @pool[id] }
    end

    def room
      @room ||= @storage.client_room(client_id)
    end

    def client_id
      @pool.inverted_pool[@websocket]
    end

    def message
      VegaServer::OutgoingMessages::PeerHangUp.new(client_id)
    end
  end
end
