module VegaServer
  module Cleanable
    include Meddleable

    attr_reader :websocket

    def initialize(websocket)
      @websocket = websocket
    end

    def handle
      send_messages
      remove_client
      after_remove_client
      dispense_websocket
    end

    private

    def send_messages
      room_peer_websockets.each do |websocket|
        VegaServer::OutgoingMessages.send_message(websocket, message)
      end
    end

    def room_peer_websockets
      room.reject do |key|
        key == client_id
      end.map { |id| pool[id] }
    end

    def room
      storage.client_room(client_id)
    end

    def client_id
      pool.inverted_pool[websocket]
    end

    def remove_client
      storage.remove_client(client_id)
      pool.delete(client_id)
    end

    def after_remove_client
    end

    def dispense_websocket
      @websocket = nil
    end

    def outgoing_message_class
      raise NotImplementedError
    end

    def message
      outgoing_message_class.new(client_id)
    end
  end
end
