require 'multi_json'

module VegaServer::Events
  class Message
    def initialize(websocket, event, origin)
      @websocket = websocket
      @event     = event
      @pool      = VegaServer.connection_pool
      @storage   = VegaServer.storage
    end

    def handle
      data        = @event.data
      client_data = MultiJson.load(data)['payload']

      client_id = @pool.add!(@websocket)
      room_id   = client_data.delete('roomId')

      @storage.add_to_room(room_id, client_id, client_data)

      message  = { event: 'callerSuccess',  payload: {} }
      response = MultiJson.dump(message)

      @websocket.send(response)
    end

    def self.handle(websocket, event, origin)
      new(websocket, event, origin).handle
    end
  end
end
