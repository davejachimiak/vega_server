require 'multi_json'

module VegaServer
  class OnMessage
    def initialize(websocket)
      @ws   = websocket
      @pool = VegaServer.connection_pool
    end

    def call
      @ws.on :message do |event|
        data    = event.data
        message = MultiJson.load(data)

        client_id = SecureRandom.uuid
        @pool[client_id] = @ws

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
