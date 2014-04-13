require 'multi_json'

module VegaServer::Events
  class Message
    include Handleable

    def initialize(*args)
      @pool      = VegaServer.connection_pool
      @storage   = VegaServer.storage

      super
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
  end
end
