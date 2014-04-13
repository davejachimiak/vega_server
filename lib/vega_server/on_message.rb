require 'multi_json'

module VegaServer
  class OnMessage
    def initialize(websocket)
      @ws      = websocket
      @pool    = VegaServer.connection_pool
      @storage = VegaServer.storage
    end

    def call
      @ws.on :message do |event|
        data    = event.data
        client_data = MultiJson.load(data)['payload']

        client_id = SecureRandom.uuid
        room_id = client_data.delete('roomId')
        @pool[client_id] = @ws
        client_data = client_data.merge(client_id: client_id)
        @storage.add_to_room(room_id, client_data)

        message  = { event: 'callerSuccess',  payload: {} }
        response = MultiJson.dump(message)

        @ws.send(response)
      end
    end

    def self.call(ws)
      new(ws).call
    end
  end
end
