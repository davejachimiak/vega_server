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
      room_id   = @payload.delete(:room_id)

      @storage.add_to_room(room_id, client_id, @payload)

      message  = { event: 'callerSuccess',  payload: {} }
      response = MultiJson.dump(message)

      @websocket.send(response)
    end

    def self.handle(websocket, payload)
      new(websocket, payload).handle
    end
  end
end
