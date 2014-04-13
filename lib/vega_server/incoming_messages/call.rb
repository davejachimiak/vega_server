module VegaServer::IncomingMessages
  class Call
    def initialize(websocket, payload)
      @websocket = websocket
      @payload   = payload
      @room_id   = payload.delete(:room_id)
      @pool      = VegaServer.connection_pool
      @storage   = VegaServer.storage
    end

    def handle
      client_id = @pool.add!(@websocket)

      message = if room_is_empty?
                  { type: 'callerSuccess',  payload: {} }
                elsif peers_and_clients_match?
                  { type: 'calleeSuccess',  payload: {} }
                else
                  { type: 'unacceptablePeerTypeError',  payload: {} }
                end

      if peers_and_clients_match?
        @storage.add_to_room(@room_id, client_id, @payload)
      end

      response = MultiJson.dump(message)
      @websocket.send(response)
    end

    def self.handle(websocket, payload)
      new(websocket, payload).handle
    end

    private

    def peers_and_clients_match?
      return true unless room
      peers_are_acceptable? && client_is_acceptable?
    end

    def peers_are_acceptable?
      first_room_peer_data[:client_types].any? do |client_type|
        @payload[:acceptable_peer_types].include?(client_type)
      end
    end

    def client_is_acceptable?
      first_room_peer_data[:acceptable_peer_types].any? do |acceptable_peer_type|
        @payload[:client_types].include?(acceptable_peer_type)
      end
    end

    def first_room_peer_data
      room.first.last
    end

    def room
      @storage.room(@room_id)
    end

    def room_is_empty?
      @storage.room_is_empty?(@room_id)
    end
  end
end
