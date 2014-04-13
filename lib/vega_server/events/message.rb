require 'vega_server/json'

module VegaServer::Events
  class Message
    include Handleable

    def initialize(*args)
      @pool    = VegaServer.connection_pool
      @storage = VegaServer.storage

      super
    end

    def handle
      case type
      when 'call'
        client_id = @pool.add!(@websocket)
        room_id   = payload.delete(:room_id)

        @storage.add_to_room(room_id, client_id, payload)

        message  = { event: 'callerSuccess',  payload: {} }
        response = MultiJson.dump(message)

        @websocket.send(response)
      end
    end

    private

    def type
      data.type
    end

    def payload
      data.payload
    end

    def data
      @data ||= VegaServer::Json.to_struct(raw_data)
    end

    def raw_data
      event.data
    end
  end
end
