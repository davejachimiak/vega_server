module VegaServer::IncomingMessages
  class Call
    def initialize(websocket, payload)
      @websocket = websocket
      @payload   = payload
      @pool      = VegaServer.connection_pool
      @storage   = VegaServer.storage
    end

    def handle
      client_id = @pool.add!(@websocket)

      message = if room_is_empty?
                  { type: 'callerSuccess',  payload: {} }
                else
                  { type: 'calleeSuccess',  payload: {} }
                end

      @storage.add_to_room(room_id, client_id, @payload)

      response = MultiJson.dump(message)
      @websocket.send(response)
    end

    def self.handle(websocket, payload)
      new(websocket, payload).handle
    end

    private

    def room_id
      @room_id ||= @payload.delete(:room_id)
    end

    def room_is_empty?
      !@storage[room_id]
    end
  end
end
