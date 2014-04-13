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
                elsif peers_are_acceptable?
                  { type: 'calleeSuccess',  payload: {} }
                else
                  { type: 'unacceptablePeerTypeError',  payload: {} }
                end

      if peers_are_acceptable?
        @storage.add_to_room(@room_id, client_id, @payload)
      end

      response = MultiJson.dump(message)
      @websocket.send(response)
    end

    def self.handle(websocket, payload)
      new(websocket, payload).handle
    end

    private

    def peers_are_acceptable?
      room = @storage[@room_id]

      return true unless room

      q1 = room.first.last[:client_types].any? do |client_type|
        @payload[:acceptable_peer_types].include?(client_type)
      end

      q2 = room.first.last[:acceptable_peer_types].any? do |acceptable_peer_type|
        @payload[:client_types].include?(acceptable_peer_type)
      end

      q1 && q2
    end

    def room_is_empty?
      @storage.room_is_empty?(@room_id)
    end
  end
end
